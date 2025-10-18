resource "aws_ecs_cluster" "tripmgmt_cluster" {
  name = "ecs-cluster-tripmgmtdemo"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecsInstanceRole.name
}

# Launch Template (defines what each EC2 instance looks like)
resource "aws_launch_template" "asg_lt" {
  name_prefix   = "asg-lt-"
  image_id      = var.ami_id
  instance_type = var.ec2_instance

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                = "ecs-tripmgmt-asg"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = data.aws_subnets.default_vpc_subnets.ids

  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ecs-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "asg_cp" {
  name = "ec2-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 75
    }
  }
}

# Attach Capacity Provider to ECS Cluster 
resource "aws_ecs_cluster_capacity_providers" "ecs_cp_attach" {
  cluster_name = aws_ecs_cluster.tripmgmt_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.asg_cp.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.asg_cp.name
    weight            = 1
  }
}

/*
resource "aws_ecs_cluster_capacity_providers" "fargate_cp" {
  cluster_name = aws_ecs_cluster.tripmgmt_cluster.name 

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
*/

# Security Group for EC2 Container Instance
resource "aws_security_group" "ecs_container_sg" {
  name        = "ECS-ALB-SecurityGroup"
  description = "Allow access to Trip Management Monolith Application."
  vpc_id      = var.vpc_id

  tags = {
    Name = "alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_80_port_ec2" {
  security_group_id = aws_security_group.ecs_container_sg.id
  cidr_ipv4         = "${chomp(data.http.my_ip.response_body)}/32"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080_port_ec2" {
  security_group_id = aws_security_group.ecs_container_sg.id
  cidr_ipv4         = "${chomp(data.http.my_ip.response_body)}/32"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_ecs_task_definition" "tripmgmt" {
  family                   = "task-tripmgmt-demo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = jsonencode([
    {
      name      = "cntr-img-tripmgmt"
      image     = docker_registry_image.tripmgmt.name
      essential = true

      entryPoint = []

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "JAVA_OPTS"
          value = "-Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses"
        },
        {
          name  = "JHIPSTER_SLEEP"
          value = "0"
        },
        {
          name  = "SPRING_DATASOURCE_URL"
          value = "jdbc:postgresql://${aws_rds_cluster.aurora_postgres.endpoint}:5432/tripmgmt"
        },
        {
          name  = "SPRING_DATASOURCE_USERNAME"
          value = var.db_username
        },
        {
          name  = "SPRING_DATASOURCE_PASSWORD"
          value = random_password.db_password.result
        },
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = "prod,swagger"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "awslogs-tripmgmtdemo-ecstask"
        }
        secretOptions = []
      }
    }
  ])
}

resource "aws_ecs_service" "tripmgmt_svc" {
  name            = "tripmgmt-svc"
  cluster         = aws_ecs_cluster.tripmgmt_cluster.id
  task_definition = aws_ecs_task_definition.tripmgmt.arn
  desired_count   = 2
  depends_on      = [aws_iam_role.ecsTaskExecutionRole]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_80.arn
    container_name   = var.container_name
    container_port   = 8080
  }

  network_configuration {
    subnets = [
      var.subnets["us-east-1a"],
      var.subnets["us-east-1b"],
      var.subnets["us-east-1c"]
    ]
    security_groups  = [aws_security_group.ecs_container_sg.id]
  }

  deployment_configuration {
    strategy = "BLUE_GREEN"
  }
  
  /*
  advanced_configuration {
    alternate_target_group_arn = aws_lb_target_group.alb_target_8080.arn
    production_listener_rule   = aws_lb_listener.port_80_listener.arn
    role_arn                   = aws_iam_role.ecsInstanceRole.arn
  }
  */

  sigint_rollback       = true
  wait_for_steady_state = true
}
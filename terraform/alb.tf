# IP Address target group
resource "aws_lb_target_group" "alb_target_80" {
  name        = "alb-tg-tripmgmtdemo-1"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default_vpc.id
}

resource "aws_lb_target_group" "alb_target_8080" {
  name        = "alb-tg-tripmgmtdemo-2"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default_vpc.id
}

# ALBSecurityGroup
resource "aws_security_group" "alb_sg" {
  name        = "ALBSecurityGroup"
  description = "Allow access to Trip Management Monolith Application."
  vpc_id      = data.aws_vpc.default_vpc.id

  tags = {
    Name = "alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_80_port" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = ["${chomp(data.http.my_ip.response_body)}/32"]
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080_port" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = ["${chomp(data.http.my_ip.response_body)}/32"]
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

# This will be the public endpoint to access Trip Management Monolith Application.
resource "aws_lb" "app_alb" {
  name               = "tripmgmtdemo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.subnets["us-east-1a"], var.subnets["us-east-1b"]]

  enable_deletion_protection = true

  tags = {
    Environment = "dev"
  }
}

# ALB listeners for ports 80 and 8080
resource "aws_lb_listener" "port_80_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_80.arn
  }
}

resource "aws_lb_listener" "port_8080_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_8080.arn
  }
}
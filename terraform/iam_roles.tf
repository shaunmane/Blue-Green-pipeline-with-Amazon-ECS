# Task Execution Role
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"

  # This is the standard Trust Relationship for ECS Tasks
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# This uses the ARN for the official policy, which should be SCP-compliant.
resource "aws_iam_role_policy_attachment" "ecs_execution_role_attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Container Instance Role
resource "aws_iam_role" "ecsInstanceRole" {
  name = "ecsInstanceRole"

  # Standard Trust Relationship for EC2 instances used by ECS
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attaches the AWS-Managed Policy to grant necessary permissions to the EC2 instances.
resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role       = aws_iam_role.ecsInstanceRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


# This is required for EC2 instances to assume the IAM Role.
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecsInstanceRole.name
}

# Service Linked Role for Amazon EC2 Auto Scaling
resource "aws_iam_service_linked_role" "AWSServiceRoleForAutoScaling" {
  aws_service_name = "autoscaling.amazonaws.com"
}

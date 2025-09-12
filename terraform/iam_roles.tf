# Task Execution Role
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = file("${path.module}/iam_roles/AmazonECSTaskExecutionRolePolicy.json")
}

# ECS Container Instance Role
resource "aws_iam_role" "ecsInstanceRole" {
  name = "ecsInstanceRole"
  assume_role_policy = file("${path.module}/iam_roles/AmazonEC2ContainerServiceforEC2Role.json")
}

# Service Linked Role for Amazon ECS
resource "aws_iam_service_linked_role" "AWSServiceRoleForECS" {
  aws_service_name = "ecs.amazonaws.com"
}

# Service Linked Role for Amazon EC2 Auto Scaling
resource "aws_iam_service_linked_role" "AWSServiceRoleForAutoScaling" {
  aws_service_name = "autoscaling.amazonaws.com"
}

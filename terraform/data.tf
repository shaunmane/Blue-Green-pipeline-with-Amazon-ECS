data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_ecr_authorization_token" "ecr" {}

data "aws_vpc" "default_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

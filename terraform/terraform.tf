terraform {
  required_version = ">= 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "s3" {
    bucket       = aws_s3_bucket.tf_state.name
    key          = "ecs-project/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.aws_region
}
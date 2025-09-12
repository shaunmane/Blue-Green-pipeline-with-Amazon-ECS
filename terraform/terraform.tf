terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.13.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "s3" {
    bucket = "value"
    region = "value"
    dynamodb_table = "value"
  }
}

provider "aws" {
  region = var.aws_region
}
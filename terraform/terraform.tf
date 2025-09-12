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
    bucket = aws_s3_bucket.tf_state.name
    key = "/terraform.tfstate"
    region = var.aws_region
    use_lockfile = true
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}
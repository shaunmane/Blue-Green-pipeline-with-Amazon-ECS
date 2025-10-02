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
    bucket       = "ecs-workshop-tf-state-bucket"
    key          = "ecs-project/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}
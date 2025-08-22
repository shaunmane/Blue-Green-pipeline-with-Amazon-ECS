terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.98.0"
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
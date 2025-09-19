variable "vpc_cidr" {
  description = "CIDR Range for lab VPC"
  type        = string
}

variable "azs_use1" {
  description = "Availability Zones for the region"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR ranges for the private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for the private subnets"
  type        = list(string)
}

variable "aws_region" {
  description = "Region used for the services"
  type        = string
}

variable "repo_name" {
  description = "Name of the container repository"
  type        = string
}
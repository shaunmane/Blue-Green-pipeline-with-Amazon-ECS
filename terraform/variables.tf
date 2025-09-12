variable "vpc_cidr" {
  description = "CIDR Range for lab VPC"
  type = string
}

variable "azs_use1" {
  description = "Availability Zones for the region"
  type = list()
}

variable "private_subnet_cidrs" {
  description = "CIDR ranges for the private subnets"
  type = list()
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for the private subnets"
  type = list()
}

variable "aws_region" {
  description = "Region used for the services"
  type = string 
}
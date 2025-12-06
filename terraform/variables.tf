variable "vpc_id" {
  description = "VPC ID of the default VPC"
  type        = string
}

variable "subnets" {
  description = "Subnet IDs in the default VPC"
  type        = map(string)
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

variable "rds_aurora_name" {
  description = "Name of the Aurora PostgreSQL database"
  type        = string
  default     = "tripmgmtdb-cluster"
}

variable "engine" {
  description = "Engine type for the db"
  type        = string
}

variable "aurora_engine_version" {
  description = "Engine version for aurora db"
  type        = string
}

variable "db_username" {
  description = "Username for my db"
  type        = string
}
variable "db_instance" {
  description = "DB instance type"
  type        = string
}

variable "ami_id" {
  description = "DB instance type"
  type        = string
}

variable "ec2_instance" {
  description = "ECS asg instance type"
  type        = string
}

variable "container_name" {
  description = "Container name for the esc service"
  type        = string
}

variable "pipeline_bucket" {
  description = "S3 bucket for AWS Code Pipeline Artifacts"
  type        = string
}

variable "codebuild_project" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "codedeploy_app" {
  description = "Name of the CodeDeployment App"
  type        = string
}

variable "deployment_group" {
  description = "Name of the deployment group"
  type        = string
}

variable "ecs_cluster" {
  description = "Name of the ECS Cluster"
  type        = string
}

variable "ecs_capacity_provider" {
  description = "Name of the ECS capacity provider"
  type        = string
}

variable "ecs_alb_sg" {
  description = "Name of ECS security group"
  type        = string
}

variable "ecs_asg" {
  description = "Name of the ECS Auto Scaling Group"
  type        = string
}

variable "ecs_svc" {
  description = "Name of the ECS service"
  type        = string
}
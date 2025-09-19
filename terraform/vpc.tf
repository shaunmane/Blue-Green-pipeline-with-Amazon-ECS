module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.0"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs_use1
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
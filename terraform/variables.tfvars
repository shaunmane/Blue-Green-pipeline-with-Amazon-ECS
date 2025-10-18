vpc_id = "vpc-08c839b0654e7436b"

subnets = {
  "us-east-1a" = "subnet-07e78edf0d0ed7748"
  "us-east-1b" = "subnet-08764ac63daa1065d"
  "us-east-1c" = "subnet-0f140c30cb0cf135c"
  "us-east-1d" = "subnet-01520033b7a71712e"
  "us-east-1e" = "subnet-0375ad98382400f62"
  "us-east-1f" = "subnet-02af679b67073070b"
}

azs_use1             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
aws_region           = "us-east-1"
# Security group to allow access
resource "aws_security_group" "aurora_sg" {
  name        = "aurora-postgres-sg"
  description = "Allow PostgreSQL traffic"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # restrict in production!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Subnet group for Aurora
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = [var.subnets["us-east-1a"], var.subnets["us-east-1b"]]

  tags = {
    Name = "aurora-subnet-group"
  }
}

# Generate a random password
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Store password in SSM Parameter Store
resource "aws_ssm_parameter" "aurora_password" {
  name        = "/app/secure/password"
  description = "Randomly generated password for Aurora DB"
  type        = "SecureString"
  value       = random_password.db_password.result
  overwrite   = true
}

# Aurora PostgreSQL cluster
resource "aws_rds_cluster" "aurora_postgres" {
  cluster_identifier     = "tripmgmtdb-cluster"
  engine                 = var.engine
  engine_version         = var.aurora_engine_version
  master_username        = var.db_username
  master_password        = random_password.db_password.result
  database_name          = "tripmgmt"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.aurora_subnet_group.name
}

# Aurora cluster instances (at least one required)
resource "aws_rds_cluster_instance" "aurora_postgres_instance" {
  count                = 2
  identifier           = "aurora-postgres-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.aurora_postgres.id
  instance_class       = var.db_instance
  engine               = aws_rds_cluster.aurora_postgres.engine
  engine_version       = aws_rds_cluster.aurora_postgres.engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.name
}
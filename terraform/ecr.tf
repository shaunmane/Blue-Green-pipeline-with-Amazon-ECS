# Containter Repo
resource "aws_ecr_repository" "tripmgmtdemo" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  #Uses the default AWS managed key for ECR.
  encryption_configuration {
    encryption_type = KMS
  }
}


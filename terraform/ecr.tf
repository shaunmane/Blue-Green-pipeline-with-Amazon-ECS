# Containter Repo
resource "aws_ecr_repository" "tripmgmtdemo" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
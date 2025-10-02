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

# Build and Push the Docker Image
resource "docker_image" "tripmgmt" {
  name = "${aws_ecr_repository.tripmgmtdemo.repository_url}:latest"
  build {
    context    = "${path.module}/tripmgmt"  
    dockerfile = "Dockerfile"
  }
}

resource "docker_registry_image" "tripmgmt" {
  name = docker_image.tripmgmt.name
}
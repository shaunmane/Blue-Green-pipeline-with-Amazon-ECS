# S3 Bucket for Terraform state
resource "aws_s3_bucket" "tf_state" {
  bucket = "my-terraform-ecs-state-bucket"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "terraform-backend"
    Environment = "Dev"
  }
}

# Enable verisoning for state history
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
# Private ECR Registry Policy
resource "aws_ecr_registry_policy" "blue_green_deployment" {
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "testpolicy",
        Effect = "Allow",
        Principal = {
          "AWS" : "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = [
          "ecr:ReplicateImage"
        ],
        Resource = [
          "arn:${data.aws_partition.current.partition}:ecr:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:repository/*"
        ]
      }
    ]
  })
}



resource "aws_ecr_repository" "foo" {
  name                 = "bar"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
# Task Execution Role
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"

  # Standard Trust Relationship for ECS Tasks
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Container Instance Role
resource "aws_iam_role" "ecsInstanceRole" {
  name = "ecsInstanceRole"

  # Standard Trust Relationship for EC2 instances used by ECS
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# AWS-Managed Policy to grant necessary permissions to the EC2 instances.
resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role       = aws_iam_role.ecsInstanceRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# EC2 instances to assume the IAM Role.
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecsInstanceRole.name
}

# Service Linked Role for Amazon EC2 Auto Scaling
resource "aws_iam_service_linked_role" "AWSServiceRoleForAutoScaling" {
  aws_service_name = "autoscaling.amazonaws.com"
}

######## ---- Codepipeline ---- #########
resource "aws_iam_role" "codepipeline" {
  name = "codepipeline_role"

  # Standard Trust Relationship for Codepipeline
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pipeline_execution_role_attachment" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_iam_role_policy_attachment" "build_execution_role_attachment_pipeline" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_iam_role_policy_attachment" "build_execution_role_attachment_deploy" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# policy for codepipeline accessing s3
resource "aws_iam_role_policy" "codepipeline_s3_access" {
  name = "CodePipelineS3SourceAccess"
  role = aws_iam_role.codepipeline.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "s3-object-lambda:*"
        ]
        Resource = "*"
      }
    ]
  })
}

######## ----- CodeBuild ----- #########
resource "aws_iam_role" "codebuild" {
  name = "codebuild_role"

  # Standard Trust Relationship for Codebuild
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "build_execution_role_attachment" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_iam_role_policy" "codebuild_logs_access" {
  name = "CodeBuildLogsAccess"
  role = aws_iam_role.codebuild.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "tag:TagResource",
          "tag:UntagResource",
          "tag:GetResources",
          "tag:GetTagKeys",
          "tag:GetTagValues",

          # Service-specific tagging
          "s3:PutBucketTagging",
          "s3:DeleteBucketagging",
          "codebuild:TagResource",
          "codepipeline:TagResource",
          "codedeploy:TagResource",
          "codedeploy:UntagResource",
          "s3:*",
          "s3-object-lambda:*",
          "ecr:*",
          "ecs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

######## ----- CodeDeploy ----- #########
resource "aws_iam_role" "codedeploy" {
  name = "codedeploy_role"

  # Standard Trust Relationship for Codedeploy
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "deploy_execution_role_attachment" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role_policy" "codedeploy_access" {
  name = "CodeDeployAccess"
  role = aws_iam_role.codedeploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:*",
          "tag:*",
          "s3:*",
          "s3-object-lambda:*",
          "ecr:*",
          "ecs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "artifact_policy" {
  bucket = aws_s3_bucket.source.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "AllowCodePipelineAndCodeDeployReadArtifacts",
        Effect : "Allow",
        Principal : {
          AWS : [
            aws_iam_role.codepipeline.arn,
            aws_iam_role.codedeploy.arn
          ]
        },
        Action : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketLocation"
        ],
        Resource : [
          "${aws_s3_bucket.source.arn}",
          "${aws_s3_bucket.source.arn}/*"
        ]
      }
    ]
  })
}

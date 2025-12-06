# S3 bucket to store source artifacts
resource "aws_s3_bucket" "source" {
  bucket = var.pipeline_bucket

  force_destroy = true
}

data "archive_file" "tripmgmt_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../tripmgmt"
  output_path = "${path.module}/tripmgmt.zip"
}

resource "aws_s3_object" "tripmgmt_zip" {
  bucket = aws_s3_bucket.source.bucket
  key    = "tripmgmt.zip"
  source = data.archive_file.tripmgmt_zip.output_path
  etag   = filemd5(data.archive_file.tripmgmt_zip.output_path)
}

resource "aws_s3_bucket_versioning" "versioning_source" {
  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "source_policy" {
  bucket = aws_s3_bucket.source.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "CodePipelineS3Access",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.codepipeline.arn
        },
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.source.arn,
          "${aws_s3_bucket.source.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_codepipeline" "codepipeline" {
  depends_on = [aws_s3_object.tripmgmt_zip]

  name     = "tripmgmt-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.source.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "S3Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        S3Bucket    = aws_s3_bucket.source.bucket
        S3ObjectKey = "tripmgmt.zip"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "CodeBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.tripmgmt_build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployToECS"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ApplicationName            = aws_codedeploy_app.frontend.name
        DeploymentGroupName        = aws_codedeploy_deployment_group.frontend.deployment_group_name
        TaskDefinitionTemplateFile = "taskdef.json"
        AppSpecTemplateFile        = "appspec-template.yml"
        ImageDefinitionsFile       = "imagedefinitions.json"
      }
    }
  }
}

resource "aws_codepipeline_custom_action_type" "build" {
  category = "Build"

  input_artifact_details {
    maximum_count = 1
    minimum_count = 0
  }

  output_artifact_details {
    maximum_count = 3
    minimum_count = 0
  }

  provider_name = aws_codebuild_project.tripmgmt_build.name
  version       = "1"
}
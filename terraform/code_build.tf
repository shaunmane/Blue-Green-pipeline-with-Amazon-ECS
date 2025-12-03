resource "aws_codebuild_project" "tripmgmt_build" {
  name          = "tripmgmt-build"
  description   = "Builds and pushes Docker image for tripmgmt to ECR"
  service_role  = aws_iam_role.codebuild.arn
  build_timeout = 30

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_MEDIUM"
    image           = "aws/codebuild/amazonlinux-x86_64-standard:corretto11"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "YOUR_REPOSITORY_URI"
      value = aws_ecr_repository.tripmgmt.repository_url
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = <<EOF
version: 0.2

phases:
  install:
    runtime-versions:
      java: corretto11 
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
      - echo Downloading tripmgmt app ZIP...
      - wget "https://static.us-east-1.prod.workshops.aws/public/3f41e691-93ab-44aa-b826-51bd51b55e54/static/reference-files/tripmgmt-7_9_3.zip" -O tripmgmt.zip
      - echo Extracting ZIP...
      - mkdir tripmgmt
      - unzip tripmgmt.zip -d tripmgmt
      - REPOSITORY_URI=$YOUR_REPOSITORY_URI
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=build-$(echo $CODEBUILD_BUILD_ID | awk -F":" '{print $2}')

  build:
    commands:
      - echo Build started on `date`
      - chmod 775 ./gradlew
      - ./gradlew clean
      - ./gradlew bootWar -Pprod -Pwar
      - echo Building Docker image...
      - docker build -t $REPOSITORY_URI:latest .
      - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG

  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing Docker images...
      - docker push $REPOSITORY_URI:latest
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - echo Creating imagedefinitions.json...
      - printf '[{"name":"tripmgmt","imageUri":"%s"}]' "$REPOSITORY_URI:$IMAGE_TAG" > imagedefinitions.json

artifacts:
  files:
    - imagedefinitions.json
EOF
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/tripmgmt-build"
      stream_name = "build-log"
    }
  }

  tags = {
    Project = "tripmgmt"
    Managed = "terraform"
  }
}

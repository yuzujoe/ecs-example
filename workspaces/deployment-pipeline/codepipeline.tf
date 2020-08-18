#####################
# Code Build
#####################

data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "iam:PassRole",
    ]
  }
}

module "codepipeline_role" {
  source     = "../modules/iam_role"
  name       = "codepipeline"
  identifier = "codepipeline.amazonaws.com"
  policy     = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_codepipeline" "ecs_example" {
  name     = "ecs-example"
  role_arn = module.codepipeline_role.iam_role_arn

  artifact_store {
    location = aws_s3_bucket.artifact.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category         = "Source"
      name             = "Source"
      owner            = "ThirdParty"
      provider         = "Github"
      version          = 1
      output_artifacts = ["Source"]

      configuration = {
        Owner                = "your-github-name"
        Repo                 = "your-repository"
        Branch               = "master"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["Source"]
      output_artifacts = ["Build"]

      configuration = {
        ProjectName = aws_codebuild_project.ecs_example.id
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      category        = "Deploy"
      name            = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["Build"]

      configuration = {
        ClusterName = "aws_ecs_cluster.example.name"
        ServiceName = "aws_ecs_service.example.name"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "ecs_example" {
  authentication  = "GITHUB_HMAC"
  name            = "ecs-example"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.ecs_example.name

  authentication_configuration {
    secret_token = "VeryRandomStringMoreThan20Byte!"
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

#####################
# Artifact Store
#####################

resource "aws_s3_bucket" "artifact" {
  bucket = "artifact-ecs-example"

  lifecycle_rule {
    enabled = false

    expiration {
      days = "30"
    }
  }
}

#####################
# Github Webhook
#####################

resource "github_repository_webhook" "ecs_example" {
  events     = ["push"]
  repository = "your-repository"

  configuration {
    url          = aws_codepipeline_webhook.ecs_example.url
    secret       = "VeryRandomStringMoreThan20Byte!"
    content_type = "json"
    insecure_ssl = false
  }
}

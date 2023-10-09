resource "aws_codepipeline" "example" {
  name     = "example-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner              = "yourusername"
        Repo               = "your-repo-name"
        Branch             = "main"
        OAuthToken         = "YOUR_GITHUB_OAUTH_TOKEN"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "BuildAction"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }

stage {
    name = "Test"

    action {
      name             = "TestAction"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["build_output"]
      output_artifacts = ["test_output"]

      configuration = {
        ProjectName = aws_codebuild_project.test_project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["test_output"]
      version         = "1"

      configuration = {
        ApplicationName  = aws_elastic_beanstalk_application.nodejs_app.name
        EnvironmentName  = aws_elastic_beanstalk_environment.nodejs_env.name
        ActionMode       = "CHANGE_SET_REPLACE"
      }
    }
  }
}

# Role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "CodePipelineRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

# Policy for CodePipeline
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "CodePipelinePolicy"
  role = aws_iam_role.codepipeline_role.id

  # You may need to fine-tune these permissions based on your AWS setup.
  policy = file("./jsons/codepipeline_policy.json")
}


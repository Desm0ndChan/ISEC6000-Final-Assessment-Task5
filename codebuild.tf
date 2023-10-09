resource "aws_codebuild_project" "build_project" {
  name          = "example-project"
  description   = "Example Project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/yourusername/your-repo-name.git"
    git_clone_depth = 1
    # You can specify auth here if your repo is private
    # auth {
    #   type     = "OAUTH"
    #   resource = "YOUR_GITHUB_OAUTH_TOKEN"
    # }
  }
}

resource "aws_codebuild_project" "test_project" {
  name          = "example-test-project"
  description   = "Test project for CodePipeline"
  build_timeout = "15"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = file("./spec/test_buildspec.yml")
  }
}

# Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# Policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "CodeBuildPolicy"
  role = aws_iam_role.codebuild_role.id

  # Adjust these permissions as needed.
  policy = file("./jsons/codebuild_policy.json")
}

locals {
  aws_credentials = csvdecode(file(var.aws_credentials))
}

locals {
  github_token = trimspace(file(var.github_token))
}
provider "aws" {
  access_key = local.aws_credentials["Access key ID"]
  secret_key = local.aws_credentials["Secret access key"]
  region     = var.aws_region
}

provider "github" {
  token        = local.github_token
  organization = "Desm0ndChan" 
}

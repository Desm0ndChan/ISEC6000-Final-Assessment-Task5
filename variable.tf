variable "aws_credentials" {
  description = "Path to the AWS credentials file"
  default     = "./.secrets"
  sensitive = true
}

variable "github_token" {
  description = "Path to the GitHub token file"
  default     = "./.token"
  sensitive = true
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-2"
}
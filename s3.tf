resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "your-unique-bucket-name"
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.codepipeline_bucket]

  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}
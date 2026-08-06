# This is an INTENTIONALLY insecure S3 bucket, for testing our scanner

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-test-insecure-bucket-12345"
}

resource "aws_s3_bucket_public_access_block" "insecure_bucket_access" {
  bucket = aws_s3_bucket.insecure_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
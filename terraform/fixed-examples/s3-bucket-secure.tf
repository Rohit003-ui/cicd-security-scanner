# This is a SECURE, fixed version of the S3 bucket

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-test-secure-bucket-12345"
}

resource "aws_s3_bucket_public_access_block" "secure_bucket_access" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_logging" "secure_bucket_logging" {
  bucket        = aws_s3_bucket.secure_bucket.id
  target_bucket = aws_s3_bucket.secure_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_lifecycle_configuration" "secure_bucket_lifecycle" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_notification" "secure_bucket_notification" {
  bucket      = aws_s3_bucket.secure_bucket.id
  eventbridge = true
}

resource "aws_s3_bucket" "replica_bucket" {
  bucket = "my-test-secure-bucket-replica-12345"
}

resource "aws_s3_bucket_public_access_block" "replica_bucket_access" {
  bucket = aws_s3_bucket.replica_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "replica_bucket_versioning" {
  bucket = aws_s3_bucket.replica_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replica_bucket_encryption" {
  bucket = aws_s3_bucket.replica_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_logging" "replica_bucket_logging" {
  bucket        = aws_s3_bucket.replica_bucket.id
  target_bucket = aws_s3_bucket.replica_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_lifecycle_configuration" "replica_bucket_lifecycle" {
  bucket = aws_s3_bucket.replica_bucket.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_notification" "replica_bucket_notification" {
  bucket      = aws_s3_bucket.replica_bucket.id
  eventbridge = true
}

resource "aws_iam_role" "replication_role" {
  name = "s3-bucket-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "s3.amazonaws.com"
      }
    }]
  })
}

resource "aws_s3_bucket_replication_configuration" "secure_bucket_replication" {
  depends_on = [aws_s3_bucket_versioning.secure_bucket_versioning]

  bucket = aws_s3_bucket.secure_bucket.id
  role   = aws_iam_role.replication_role.arn

  rule {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket = aws_s3_bucket.replica_bucket.arn
    }
  }
}
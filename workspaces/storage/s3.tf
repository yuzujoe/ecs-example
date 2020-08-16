#####################
# Private Bucket
#####################

resource "aws_s3_bucket" "private" {
  bucket = "private-ecs-terraform"

  versioning {
    enabled = true
  }

  // Enable server-side encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#####################
# Public Bucket
#####################

resource "aws_s3_bucket" "public" {
  bucket = "public-ecs-terraform"
  acl    = "public-read"

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["https://example.com"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}


# main.tf - SECURE VERSION
provider "aws" {
  region = "us-east-1"
}

# S3 Bucket - Secure Configuration
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-secure-bucket-123456789"  # CHANGE THIS TO UNIQUE NAME
  
  # Force destroy (for testing purposes)
  force_destroy = true
}

# Enable Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Block ALL Public Access
resource "aws_s3_bucket_public_access_block" "secure_bucket_block_public" {
  bucket = aws_s3_bucket.secure_bucket.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# (Optional) Enable logging for security monitoring
resource "aws_s3_bucket_logging" "secure_bucket_logging" {
  bucket = aws_s3_bucket.secure_bucket.id
  
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# Log bucket (must also be secured)
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-log-bucket-123456789"  # CHANGE THIS TO UNIQUE NAME
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "log_bucket_block_public" {
  bucket = aws_s3_bucket.log_bucket.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Output the bucket name for reference
output "bucket_name" {
  value = aws_s3_bucket.secure_bucket.bucket
}
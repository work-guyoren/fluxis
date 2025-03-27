# Create an S3 bucket
resource "aws_s3_bucket" "main_bucket" {
  bucket = "${var.environment}-main-bucket-${random_string.suffix.result}"

  tags = {
    Environment = var.environment
  }
}

# Generate a random suffix for the bucket name to ensure uniqueness
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# (Optional) Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Add a bucket policy to deny all public access
resource "aws_s3_bucket_policy" "main_bucket_policy" {
  bucket = aws_s3_bucket.main_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyPublicAccess",
        Effect    = "Deny",
        Principal = "*",
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource  = "${aws_s3_bucket.main_bucket.arn}/*"
      }
    ]
  })
}

# Add a bucket policy to allow ECS tasks to access the bucket
resource "aws_s3_bucket_policy" "ecs_access_policy" {
  bucket = aws_s3_bucket.main_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowECSAccess",
        Effect    = "Allow",
        Principal = {
          AWS = "${module.ecs.ecs_task_role_arn}"
        },
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource  = [
          "${aws_s3_bucket.main_bucket.arn}",
          "${aws_s3_bucket.main_bucket.arn}/*"
        ]
      }
    ]
  })
}
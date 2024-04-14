## CREATE S3 BUCKET FOR ASSETS
resource "aws_s3_bucket" "assets" {
  bucket = "${var.app_name}-${var.environment}-assets"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "assets" {
  bucket = aws_s3_bucket.assets.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "assets" {
  depends_on = [aws_s3_bucket_ownership_controls.assets]
  bucket = aws_s3_bucket.assets.id
  acl    = "private"
}

## CREATE S3 CRUD POLICY
resource "aws_iam_role_policy" "assets" {
  name = "assets"
  role = aws_iam_role.main.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource =  "${aws_s3_bucket.assets.arn}/*"         
      }]
  })
}

## ATTACH BUCKET POLICY TO S3 BUCKET
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.assets.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Effect = "Allow",
        Action = ["s3:GetObject"],
        Resource = "${aws_s3_bucket.assets.arn}/*",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.main.arn}"
          }
        }
      }]
  })
}
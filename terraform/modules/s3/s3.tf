resource "random_string" "default" {
  length           = 4
  special          = false
  upper            = false
}

resource "aws_s3_bucket" "default" {
  bucket = "${var.prefix}-${random_string.default.result}-media"
  force_destroy = true
}
resource "aws_s3_bucket_acl" "default" {
  bucket = aws_s3_bucket.default.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.default.id
  policy =  <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.default.bucket}/*",
                "arn:aws:s3:::${aws_s3_bucket.default.bucket}"
            ]
        }
    ]
}
EOF
depends_on = [
  aws_s3_bucket.default
]
}

resource "aws_s3_bucket_cors_configuration" "default" {
  bucket = aws_s3_bucket.default.id

  cors_rule {
    allowed_headers = []
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = []
  }
}

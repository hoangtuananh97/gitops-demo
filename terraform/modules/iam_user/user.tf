resource "aws_iam_user" "default" {
  name = "${var.prefix}-user"
  force_destroy = true
}

resource "aws_iam_access_key" "default" {
  user = aws_iam_user.default.name
}

resource "aws_iam_user_policy" "default" {
  name = "${var.prefix}-policy"
  user = aws_iam_user.default.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "s3-object-lambda:*",
        "rekognition:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_secretsmanager_secret" "user_secret" {
  name     = "user-account/${aws_iam_user.default.name}"
}

resource "aws_secretsmanager_secret_version" "user_secret" {
  secret_id = aws_secretsmanager_secret.user_secret.id
  secret_string = jsonencode({
    apikey    = aws_iam_access_key.default.id
    apisecret = aws_iam_access_key.default.secret
    }
  )
}

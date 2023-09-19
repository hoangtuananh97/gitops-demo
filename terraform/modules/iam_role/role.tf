resource "aws_iam_role" "default" {
  name               = "${var.prefix}-scheduler-lambda"
  description        = "Allows Lambda functions to stop and start ec2 and rds resources"
  assume_role_policy = data.aws_iam_policy_document.default.json
  tags               = var.tags
}

data "aws_iam_policy_document" "default" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy" "instance_scheduler" {
  name   = "${var.prefix}-instance-custom-policy-scheduler"
  role   = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.instance_scheduler.json
}

data "aws_iam_policy_document" "instance_scheduler" {
  statement {
    actions = [
      "ec2:StopInstances",
      "ec2:StartInstances",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "resource_groups_tag_read_only_access" {
  name   = "${var.prefix}-resource-groups-tag-read-only-access"
  role   = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.resource_groups_tag_read_only_access.json
}

data "aws_iam_policy_document" "resource_groups_tag_read_only_access" {
  statement {
    actions = [
      "tag:getResources",
      "tag:getTagKeys",
      "tag:getTagValues",
      "resource-groups:Get*",
      "resource-groups:List*",
      "resource-groups:Search*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "rds_scheduler" {
  name   = "${var.prefix}-rds-custom-policy-scheduler"
  role   = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.rds_scheduler.json
}

data "aws_iam_policy_document" "rds_scheduler" {
  statement {
    actions = [
      "rds:StartDBCluster",
      "rds:StopDBCluster",
      "rds:StartDBInstance",
      "rds:StopDBInstance",
      "rds:DescribeDBClusters",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "cloudwatch_alarm_scheduler" {
  statement {
    actions = [
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
    ]

    resources = [
      "*",
    ]
  }
}
# Local variables are used for make iam policy because
# resources cannot have a null value in aws_iam_policy_document.
locals {
  lambda_logging_policy = {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  }
  lambda_logging_and_kms_policy = {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "${var.aws_cloudwatch_log_group_arn}:*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:CreateGrant"
        ],
        "Resource" : var.kms_key_arn,
        "Effect" : "Allow"
      }
    ]
  }
  # Backward compatibility with the former scheduler variable name.
  scheduler_tag = var.resources_tag == null ? var.scheduler_tag : var.resources_tag
}
resource "aws_iam_role_policy" "lambda_logging" {
  name   = "${var.prefix}-lambda-logging"
  role   = aws_iam_role.default.id
  policy = var.kms_key_arn == null ? jsonencode(local.lambda_logging_policy) : jsonencode(local.lambda_logging_and_kms_policy)
}

resource "aws_iam_role_policy" "cloudwatch_alarm_scheduler" {
  name   = "${var.prefix}-cloudwatch-custom-policy-scheduler"
  role   = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.cloudwatch_alarm_scheduler.json
}
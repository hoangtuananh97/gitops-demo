data "aws_region" "current" {}

# Convert *.py to .zip because AWS Lambda need .zip
data "archive_file" "default" {
  type        = "zip"
  source_dir  = "${path.module}/package/"
  output_path = "${path.module}/aws-stop-start-resources.zip"
}

data "archive_file" "layer_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/venv/lib/python3.10/"
  output_path = "${path.module}/aws-stop-start-layer.zip"
}

data "aws_lambda_function" "existing_lambda_default" {
  count         = fileexists(data.archive_file.default.output_path) ? 0 : 1
  function_name = var.name
}
data "aws_lambda_layer_version" "existing_lambda_layer_default" {
  count      = fileexists(data.archive_file.layer_lambda.output_path) ? 0 : 1
  layer_name = var.lambda_layer_name
}

locals {
  source_code_lambda_hash       = fileexists(data.archive_file.default.output_path) ? filebase64sha256(data.archive_file.default.output_path) : data.aws_lambda_function.existing_lambda_default[0].source_code_hash
  source_code_lambda_layer_hash = fileexists(data.archive_file.layer_lambda.output_path) ? filebase64sha256(data.archive_file.layer_lambda.output_path) : data.aws_lambda_layer_version.existing_lambda_layer_default[0].source_code_hash
}

resource "aws_lambda_layer_version" "default" {
  layer_name               = var.lambda_layer_name
  description              = var.lambda_layer_description
  filename                 = data.archive_file.layer_lambda.output_path
  source_code_hash         = local.source_code_lambda_layer_hash
  compatible_runtimes      = var.lambda_runtime
  compatible_architectures = var.lambda_architectures
}

# Create Lambda function for stop or start aws resources
resource "aws_lambda_function" "default" {
  filename         = data.archive_file.default.output_path
  source_code_hash = local.source_code_lambda_hash
  function_name    = var.name
  role             = var.lambda_iam_role_arn
  handler          = "main.lambda_handler"
  runtime          = "python3.10"
  timeout          = "600"
  kms_key_arn      = var.kms_key_arn == null ? "" : var.kms_key_arn
  layers           = [aws_lambda_layer_version.default.arn]

  environment {
    variables = {
      AWS_REGIONS     = var.aws_regions == null ? data.aws_region.current.name : join(", ", var.aws_regions)
      SCHEDULE_ACTION = var.schedule_action
      TAG_KEY         = var.scheduler_tag_key # local.scheduler_tag["key"]
      TAG_VALUE       = var.scheduler_tag_value # local.scheduler_tag["value"]
      EC2_SCHEDULE    = tostring(var.ec2_schedule)
      RDS_SCHEDULE    = tostring(var.rds_schedule)
    }
  }

  tags = var.tags
}


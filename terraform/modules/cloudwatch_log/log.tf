resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/lambda/${var.prefix}"
  retention_in_days = 14
  tags              = var.tags
}
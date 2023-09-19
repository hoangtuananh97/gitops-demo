output "aws_cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.default.name
}

output "aws_cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.default.arn
}
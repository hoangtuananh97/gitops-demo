output "scheduler_lambda_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.default.arn
}

output "scheduler_lambda_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.default.function_name
}

output "scheduler_lambda_function_last_modified" {
  description = "The date Lambda function was last modified"
  value       = aws_lambda_function.default.last_modified
}

output "scheduler_lambda_function_version" {
  description = "Latest published version of your Lambda function"
  value       = aws_lambda_function.default.version
}

output "aws_lambda_layer_version_arn" {
  description = "Latest published version of your Lambda function"
  value       = aws_lambda_layer_version.default.arn
}

#
#output "scheduler_log_group_name" {
#  description = "The name of the scheduler log group"
#  value       = aws_cloudwatch_log_group.default.name
#}
#
#output "scheduler_log_group_arn" {
#  description = "The Amazon Resource Name (ARN) specifying the log group"
#  value       = aws_cloudwatch_log_group.default.arn
#}

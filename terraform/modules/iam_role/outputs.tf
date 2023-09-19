output "lambda_iam_role_arn" {
  description = "The ARN of the IAM role used by Lambda function"
  value       = var.custom_iam_role_arn == null ? aws_iam_role.default.arn : var.custom_iam_role_arn
}

output "lambda_iam_role_name" {
  description = "The name of the IAM role used by Lambda function"
  value       = var.custom_iam_role_arn == null ? aws_iam_role.default.name : split("/", var.custom_iam_role_arn)
}

output "scheduler_tag_key" {
  value = local.scheduler_tag["key"]
}

output "scheduler_tag_value" {
  value = local.scheduler_tag["value"]
}
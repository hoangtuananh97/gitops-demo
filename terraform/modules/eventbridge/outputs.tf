output "event-bridge-stop-ec2" {
  description = "The ARN of the IAM role used by Lambda function"
  value       = module.event-bridge-stop-start.eventbridge_schedule_ids
}

output "event-bridge-start-ec2" {
  description = "The ARN of the IAM role used by Lambda function"
  value       = module.event-bridge-stop-start.eventbridge_schedule_ids
}
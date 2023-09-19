# Terraform variables file

# Set cloudwatch events for shutingdown instances
# trigger lambda functuon every night at 22h00 from Monday to Friday
# cf doc : https://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html

variable "name" {
  description = "Define name to use for lambda function, cloudwatch event and iam role"
  type        = string
}

variable "lambda_iam_role_arn" {
  description = "Define name to use for lambda function, cloudwatch event and iam role"
  type        = string
}

variable "custom_iam_role_arn" {
  description = "Custom IAM role arn for the scheduling lambda"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key. If this configuration is not provided when environment variables are in use, AWS Lambda uses a default service key."
  type        = string
  default     = null
}

variable "aws_regions" {
  description = "A list of one or more aws regions where the lambda will be apply, default use the current region"
  type        = list(string)
  default     = null
}

variable "schedule_action" {
  description = "Define schedule action to apply on resources, accepted value are 'stop or 'start"
  type        = string
  default     = "stop"
}

variable "resources_tag" {
  # This variable has been renamed to "scheduler_tag"
  description = "DEPRECATED, use scheduler_tag variable instead"
  type        = map(string)
  default     = null
}

variable "scheduler_tag" {
  description = "Set the tag to use for identify aws resources to stop or start"
  type        = map(string)

  default = {
    "key"   = "tostop"
    "value" = "true"
  }
}

variable "ec2_schedule" {
  description = "Enable scheduling on ec2 resources"
  type        = any
  default     = false
}

variable "rds_schedule" {
  description = "Enable scheduling on rds resources"
  type        = any
  default     = false
}

variable "cloudwatch_alarm_schedule" {
  description = "Enable scheduling on cloudwatch alarm resources"
  type        = any
  default     = false
}

variable "tags" {
  description = "Custom tags on aws resources"
  type        = map(any)
  default     = null
}

variable "scheduler_tag_key" {
  description = "Custom tags on aws resources"
  type        = string
}
variable "scheduler_tag_value" {
  description = "Custom tags on aws resources"
  type        = string
}

variable "lambda_layer_name" {
  description = "Layer name lambda"
  type        = string
}

variable "lambda_layer_description" {
  description = "Name description lambda"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime lambda"
  type        = list(string)
  default     = ["python3.10"]
}

variable "lambda_architectures" {
  description = "Architectures lambda"
  type    = list(string)
  default = ["x86_64"]
}
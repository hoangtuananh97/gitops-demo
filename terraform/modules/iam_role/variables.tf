variable "prefix" {
  description = "Prefix for Resources eg. myaccount-prod"
  type = string
}

variable "tags" {
  description = "Custom tags on aws resources"
  type        = map(any)
  default     = null
}

variable "custom_iam_role_arn" {
  description = "Custom IAM role arn for the scheduling lambda"
  type        = string
  default     = null
}
variable "aws_cloudwatch_log_group_arn" {
  description = "Custom IAM role arn for the scheduling lambda"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key. If this configuration is not provided when environment variables are in use, AWS Lambda uses a default service key."
  type        = string
  default     = null
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
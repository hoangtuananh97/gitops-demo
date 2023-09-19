variable "scheduler_lambda_arn" {
  description = "Scheduler lambda arn"
  type = string
}

variable "payload_stop" {
  description = "Payload stop"
  type = any
}

variable "payload_start" {
  description = "Payload start"
  type = any
}

variable "schedule_expression_start" {
  description = "Scheduler expression start"
  type = string
}

variable "schedule_expression_stop" {
  description = "Scheduler expression stop"
  type = string
}

variable "timezone" {
  description = "Scheduler timezone"
  type = string
}

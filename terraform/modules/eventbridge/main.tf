
module "event-bridge-stop-start" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "stop-start" # "default" bus already support schedule_expression in rules

  attach_lambda_policy = true
  lambda_target_arns   = [var.scheduler_lambda_arn]

  schedules = {
    lambda-cron-stop = {
      description         = "Trigger for a Lambda stop."
      schedule_expression = var.schedule_expression_stop
      timezone            = var.timezone
      arn                 = var.scheduler_lambda_arn
      input               = jsonencode(var.payload_stop)
    },
    lambda-cron-start = {
      description         = "Trigger for a Lambda start"
      schedule_expression = var.schedule_expression_start
      timezone            = var.timezone
      arn                 = var.scheduler_lambda_arn
      input               = jsonencode(var.payload_start)
    }
  }
}

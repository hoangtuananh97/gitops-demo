module "network" {
  source    = "../modules/network"
  providers = {
    aws = aws.network
  }
  prefix                     = var.prefix
  vpc_cidr_block             = var.vpc_cidr_block
  subnet_count               = var.subnet_count
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

module "nonprod_ec2" {
  source        = "../modules/ec2"
  prefix        = var.prefix
  public_subnet = module.network.public_subnets[0]
  vpc_id        = module.network.vpc.id
  cidr_blocks   = [
    "0.0.0.0/0",
  ]
  cidr_blocks_ssh = var.allow_ips
  settings        = var.settings_web
  key_pem         = var.key_pem
  tags            = {
    "Name" : "${var.prefix}_web_instance"
  }
  cidr_blocks_jenkins = concat(var.allow_ips, [
    "192.30.252.0/22", # https://api.github.com/meta
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20",
  ])
}
#
#module "nonprod_postgres" {
#  source    = "../modules/postgres"
#  providers = {
#    aws = aws.network
#  }
#  prefix             = var.prefix
#  vpc_id             = module.network.vpc.id
#  web_sg_id          = module.nonprod_ec2.web_sg.id
#  db_password        = var.db_password
#  db_username        = var.db_username
#  private_subnet_ids = [for subnet in module.network.private_subnets : subnet.id]
#  settings           = var.settings_db
#  db_name            = var.db_name
#  tags               = {
#    "Name" : "${var.prefix}_rds"
#  }
#}

#module "nonprod_role" {
#  source                       = "../modules/iam_role"
#  aws_cloudwatch_log_group_arn = module.nonprod_cloudwatch_log.aws_cloudwatch_log_group_arn
#  prefix                       = var.prefix
#}
#
#module "nonprod_lambda" {
#  source                   = "../modules/lambda"
#  name                     = "lambda-stop-start-ec2-rds"
#  lambda_iam_role_arn      = module.nonprod_role.lambda_iam_role_arn
#  scheduler_tag_key        = module.nonprod_role.scheduler_tag_key
#  scheduler_tag_value      = module.nonprod_role.scheduler_tag_value
#  lambda_layer_description = "aws-stop-start-layer"
#  lambda_layer_name        = "aws-stop-start-layer"
#  tags                     = {
#    "Name" : "${var.prefix}_lambda_ec2_rds"
#  }
#}
#
#module "nonprod_cloudwatch_log" {
#  source = "../modules/cloudwatch_log"
#  prefix = var.prefix
#}
#
#module "nonprod_eventbridge_stop_start_ec2" {
#  count                     = var.settings_web.web_app.count
#  source                    = "../modules/eventbridge"
#  scheduler_lambda_arn      = module.nonprod_lambda.scheduler_lambda_arn
#  schedule_expression_start = "cron(0 07 ? * MON *)"
#  schedule_expression_stop  = "cron(0 23 ? * FRI *)"
#  timezone                  = var.timezone
#  payload_start             = {
#    "tags_web_instance" : module.nonprod_ec2.web_instance[count.index].tags,
#    #    "tags_rds" : module.nonprod_postgres[count.index].tags,
#    "schedule_action" : "start",
#    "aws_regions" : "ap-southeast-1"
#  }
#  payload_stop = {
#    "tags_web_instance" : module.nonprod_ec2.web_instance[count.index].tags,
#    #    "tags_rds" : module.nonprod_postgres[count.index].tags,
#    "schedule_action" : "stop",
#    "aws_regions" : "ap-southeast-1"
#  }
#}

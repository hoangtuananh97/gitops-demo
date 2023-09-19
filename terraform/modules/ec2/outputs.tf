output "web_instance" {
  value = aws_instance.web_instance
}
output "web_sg" {
  value = aws_security_group.web_sg
}
output "web_eip" {
  value = aws_eip.web_eip
}
#output "lambda_stop_name" {
#  value = module.ec2-stop-friday.scheduler_lambda_name
#}
#
#output "lambda_stop_arn" {
#  value = module.ec2-stop-friday.scheduler_lambda_arn
#}
#
#output "lambda_start_name" {
#  value = module.ec2-start-monday.scheduler_lambda_name
#}
#
#output "lambda_start_arn" {
#  value = module.ec2-start-monday.scheduler_lambda_arn
#}



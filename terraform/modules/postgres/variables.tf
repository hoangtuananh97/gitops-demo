variable "vpc_id" {}

variable "prefix" {
  description = "Prefix for Resources eg. myaccount-prod"
}
variable "web_sg_id" {
  description = "Security groups of web"
}
variable "private_subnet_ids" {
  description = "private subnet"
  type        = list(string)
}

variable "settings" {
  description = "Configuration settings"
  type        = map(any)
}
variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "tags" {
  type = map(any)
}
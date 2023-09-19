variable "vpc_id" {}

variable "prefix" {
  description = "Prefix for Resources eg. myaccount-prod"
}

variable "public_subnet" {
  description = "subnet id to host docdb"
}

variable "cidr_blocks" {
  description = "cidr blocks to open access to"
  type        = list(string)
}

variable "cidr_blocks_ssh" {
  description = "ssh cidr blocks to open access to"
  type        = list(string)
}

variable "cidr_blocks_jenkins" {
  type = list(string)
}

variable "settings" {
  description = "Configuration settings"
  type        = map(any)
}

variable "aws_ami" {
  type = string
  default = "ami-0b825ad86ddcfb907"
}

variable "tags" {
  type = map(any)
}

variable "key_pem" {
  description = "Key Pem Ec2"
  type = string
}

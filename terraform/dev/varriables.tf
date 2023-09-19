// This variable is to set the
// AWS region that everything will be
// created in
variable "aws_region" {
  default = "ap-southeast-1"
}

// This variable is to set the
// CIDR block for the VPC
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

// This variable holds the
// number of public and private subnets
variable "subnet_count" {
  description = "Number of subnets"
  type        = map(number)
  default     = {
    public  = 1,
    private = 2
  }
}

// This variable contains the configuration
// settings for the RDS instances
variable "settings_db" {
  description = "Configuration settings"
  type        = map(any)
  default     = {
    "database" = {
      allocated_storage       = 10            // storage in gigabytes
      engine                  = "postgres"       // engine type
      engine_version          = "13.7"    // engine version
      instance_class          = "db.t3.micro" // rds instance type
      db_name                 = "bumbii"    // database name
      skip_final_snapshot     = true
      parameter_group_name    = "default.postgres13"
      apply_immediately       = true
      max_allocated_storage   = 100
      backup_retention_period = 7
      backup_window           = "18:00-20:00"
      publicly_accessible     = true
    }
  }
}

// This variable contains the configuration
// settings for the EC2 instances
variable "settings_web" {
  description = "Configuration settings"
  type        = map(any)
  default     = {
    "web_app" = {
      count         = 1          // the number of EC2 instances
      instance_type = "t3.micro" // the EC2 instance
    }
  }
}

variable "public_subnet_cidr_blocks" {
  description = "Available CIDR blocks for public subnets"
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

// This variable contains the CIDR blocks
variable "private_subnet_cidr_blocks" {
  description = "Available CIDR blocks for private subnets"
  type        = list(string)
  default     = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
  ]
}

// This variable contains the database master user
variable "db_username" {
  description = "Database master user"
  type        = string
  sensitive   = true
}

// This variable contains the database master password
variable "db_password" {
  description = "Database master user password"
  type        = string
  sensitive   = true
}
variable "db_name" {
  description = "Database name"
  type        = string
}

variable "allow_ips" {
  description = "Ips allow ssh"
  type        = list(string)
}

variable "prefix" {
  type    = string
  default = "bumbii-nonprod"
}

variable "timezone" {
  type = string
}

variable "key_pem" {
  description = "Key Pem Ec2"
  type        = string
}

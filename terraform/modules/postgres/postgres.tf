#resource "random_password" "default" {
#  length           = 16
#  special          = true
#  override_special = "-_"
#}
#resource "random_string" "default" {
#  length           = 4
#  special          = false
#}

resource "aws_security_group" "db_sg" {
  name        = "${var.prefix}-postgres"
  description = "Allow DB Access"
  vpc_id      = var.vpc_id

  ingress {
    description     = "postgres"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.web_sg_id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.prefix}-postgres"
  subnet_ids = var.private_subnet_ids
}


resource "aws_db_instance" "default" {
  allocated_storage = var.settings.database.allocated_storage
  engine = var.settings.database.engine
  engine_version = var.settings.database.engine_version
  instance_class = var.settings.database.instance_class
  db_name                 = var.settings.db_name
  identifier              = "${var.prefix}-postgres"
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = var.settings.database.parameter_group_name
  apply_immediately       = var.settings.database.apply_immediately
  max_allocated_storage   = var.settings.database.max_allocated_storage
  skip_final_snapshot     = var.settings.database.skip_final_snapshot
  db_subnet_group_name    = aws_db_subnet_group.default.id
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  backup_retention_period = var.settings.database.backup_retention_period
  backup_window           = var.settings.database.backup_window
  publicly_accessible     = var.settings.database.publicly_accessible
  tags = var.tags
}

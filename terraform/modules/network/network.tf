// Check AZs
data "aws_availability_zones" "available" {
  state = "available"
}

// Create Vpc
resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = {
    Name = "vpc-${var.prefix}"
  }
}

// Create internet gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags   = {
    Name = "${var.prefix}_internet_gateway"
  }
}

// Create public subnets
resource "aws_subnet" "public_subnets" {
  count             = var.subnet_count.public
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = {
    Name = "${var.prefix}_public_subnet_${count.index}"
  }
}

// Create private subnets
resource "aws_subnet" "private_subnets" {
  count             = var.subnet_count.private
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = {
    Name = "${var.prefix}_private_subnet_${count.index}"
  }
}

// Create route Table
// Public
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "public" {
  count          = var.subnet_count.public
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

// Private
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route_table_association" "private" {
  count          = var.subnet_count.private
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}

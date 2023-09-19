output "vpc" {
  value = aws_vpc.default
}

output "private_subnets" {
  value = aws_subnet.private_subnets
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "aws_vpcs" {
  value = aws_vpc.default
}
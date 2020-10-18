output "vpc_id" {
  value = aws_vpc.ecs_vpc.id
}

output "aws_vpc_cidr" {
  value = aws_vpc.ecs_vpc.cidr_block
}

output "public_subnet_a" {
  value = aws_subnet.public_a.id
}

output "public_subnet_c" {
  value = aws_subnet.public_c.id
}

output "public_subnet_d" {
  value = aws_subnet.public_d.id
}

output "private_subnet_a" {
  value = aws_subnet.private_a.id
}

output "private_subnet_c" {
  value = aws_subnet.private_c.id
}

output "private_subnet_d" {
  value = aws_subnet.private_d.id
}

output "internet_gateway" {
  value = aws_internet_gateway.ecs-example
}

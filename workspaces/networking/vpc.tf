resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.cidr_block
  // Effectiveness of name resolution
  enable_dns_support = true
  // Automatically assigning Public DNS
  enable_dns_hostnames = true

  tags = {
    Name = "ecs-example"
  }
}

resource "aws_subnet" "public" {
  cidr_block = "10.9.0.0/24"
  vpc_id     = aws_vpc.ecs_vpc.id
  // Automatically assigning public ip address
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
}

#####################
# VPC
#####################

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

#####################
# Public Subnet
#####################

resource "aws_subnet" "public_0" {
  cidr_block              = "10.9.1.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-example-public-subnet-1a"
  }
}

resource "aws_subnet" "public_1" {
  cidr_block              = "10.9.2.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-example-public-subnet-1c"
  }
}

resource "aws_internet_gateway" "ecs-example" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ecs-example"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ecs-example"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.ecs-example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_0" {
  subnet_id      = aws_subnet.public_0.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

#####################
# Private Subnet
#####################

resource "aws_subnet" "private_0" {
  cidr_block              = "10.9.65.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "ecs-example-private-subnet-1a"
  }
}

resource "aws_subnet" "private_1" {
  cidr_block              = "10.9.66.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "ecs-example-private-subnet-1c"
  }
}

#####################
# NAT Gateway
#####################

resource "aws_eip" "nat_gateway_0" {
  vpc        = true
  depends_on = [aws_internet_gateway.ecs-example]
}

resource "aws_eip" "nat_gateway_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.ecs-example]
}

resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = aws_eip.nat_gateway_0.id
  subnet_id     = aws_subnet.public_0.id
  depends_on    = [aws_internet_gateway.ecs-example]

  tags = {
    Name = "ecs-example-nat-gateway-1"
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.ecs-example]
}

#####################
# Route Table
#####################

resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_route" "private_0" {
  route_table_id         = aws_route_table.private_0.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_0.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1" {
  route_table_id         = aws_route_table.private_1.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_0" {
  route_table_id = aws_route_table.private_0.id
  subnet_id      = aws_subnet.private_0.id
}

resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.private_1.id
  subnet_id      = aws_subnet.private_1.id
}

#####################
# Security Group
#####################

module "ecs_example_sg" {
  source = "./security_group"
  name   = "module-sg"
  vpc_id = aws_vpc.ecs_vpc.id
  port   = 80
  cidr_blocks = ["0.0.0.0/0"]
}

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

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

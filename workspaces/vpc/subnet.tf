#####################
# Public Subnet
#####################

resource "aws_subnet" "public_a" {
  cidr_block              = "10.9.1.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-example-public-subnet-1a"
  }
}

resource "aws_subnet" "public_c" {
  cidr_block              = "10.9.2.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-example-public-subnet-1c"
  }
}

resource "aws_subnet" "public_d" {
  cidr_block              = "10.9.3.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-example-public-subnet-1d"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.ecs-example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_d" {
  subnet_id      = aws_subnet.public_d.id
  route_table_id = aws_route_table.public.id
}

#####################
# Private Subnet
#####################

resource "aws_subnet" "private_a" {
  cidr_block              = "10.9.65.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "ecs-example-private-subnet-1a"
  }
}

resource "aws_subnet" "private_c" {
  cidr_block              = "10.9.66.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "ecs-example-private-subnet-1c"
  }
}

resource "aws_subnet" "private_d" {
  cidr_block              = "10.9.67.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = false

  tags = {
    Name = "ecs-example-private-subnet-1d"
  }
}

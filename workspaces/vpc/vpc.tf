#####################
# VPC
#####################

resource "aws_vpc" "ecs_vpc" {
  cidr_block = local.cidr_block
  // Effectiveness of name resolution
  enable_dns_support = true
  // Automatically assigning Public DNS
  enable_dns_hostnames = true

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

resource "aws_internet_gateway" "ecs-example" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ecs-example"
  }
}

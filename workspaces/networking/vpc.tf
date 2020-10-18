#####################
# NAT Gateway
#####################

resource "aws_eip" "nat_gateway_a" {
  vpc = true
}

resource "aws_eip" "nat_gateway_c" {
  vpc = true
}

resource "aws_eip" "nat_gateway_d" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_gateway_a.id
  subnet_id     = data.terraform_remote_state.vpc.outputs.private_subnet_a

  tags = {
    Name = "ecs-example-nat-gateway-a"
  }
}

resource "aws_nat_gateway" "nat_gateway_c" {
  allocation_id = aws_eip.nat_gateway_c.id
  subnet_id     = data.terraform_remote_state.vpc.outputs.private_subnet_c

  tags = {
    Name = "ecs-example-nat-gateway-c"
  }
}

resource "aws_nat_gateway" "nat_gateway_d" {
  allocation_id = aws_eip.nat_gateway_d.id
  subnet_id     = data.terraform_remote_state.vpc.outputs.private_subnet_d

  tags = {
    Name = "ecs-example-nat-gateway-d"
  }
}

#####################
# Route Table
#####################

resource "aws_route_table" "private_a" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "ecs-example-private-a"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "ecs-example-private-c"
  }
}

resource "aws_route_table" "private_d" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "ecs-example-private-d"
  }
}

resource "aws_route" "private_a" {
  route_table_id         = aws_route_table.private_a.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_a.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_c" {
  route_table_id         = aws_route_table.private_c.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_c.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_d" {
  route_table_id         = aws_route_table.private_d.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_d.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_a" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = data.terraform_remote_state.vpc.outputs.private_subnet_a
}

resource "aws_route_table_association" "private_c" {
  route_table_id = aws_route_table.private_c.id
  subnet_id      = data.terraform_remote_state.vpc.outputs.private_subnet_c
}

resource "aws_route_table_association" "private_d" {
  route_table_id = aws_route_table.private_d.id
  subnet_id      = data.terraform_remote_state.vpc.outputs.private_subnet_d
}

#####################
# Security Group
#####################

module "ecs_example_sg" {
  source      = "../modules/security_group"
  name        = "module-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

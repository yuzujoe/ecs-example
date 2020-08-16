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

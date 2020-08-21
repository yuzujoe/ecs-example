#####################
# Outputs
#####################

output "aws_pvc" {
  value = aws_vpc.ecs_vpc.id
}

output "aws_vpc_cidr" {
  value = aws_vpc.ecs_vpc.cidr_block
}

output "aws_subnet_private_0" {
  value = aws_subnet.private_0.id
}

output "aws_subnet_private_1" {
  value = aws_subnet.private_1.id
}

output "alb_dns_name" {
  value = aws_lb.ecs_example.dns_name
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.ecs_example.arn
}

output "domain_name" {
  value = aws_route53_record.ecs-example.name
}

output "route53_zone_name" {
  value = data.aws_route53_zone.ecs-example.name
}

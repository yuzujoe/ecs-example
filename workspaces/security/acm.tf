//########
//# ACM
//########
//
//resource "aws_acm_certificate" "ecs_example" {
//  domain_name = data.terraform_remote_state.networking.outputs.domain_name
//  subject_alternative_names = [
//    "*.joegate.work"
//  ]
//  validation_method = "DNS"
//
//  lifecycle {
//    create_before_destroy = true
//  }
//}
//
//#####################
//# DNS Verification
//#####################
//
//resource "aws_route53_record" "ecs_example_certificate" {
//  name    = aws_acm_certificate.ecs_example.domain_validation_options[0].resource_record_name
//  type    = aws_acm_certificate.ecs_example.domain_validation_options[0].resource_record_type
//  zone_id = data.terraform_remote_state.networking.outputs.route53_zone_name
//  records = [aws_acm_certificate.ecs_example.domain_validation_options[0].resource_record_value]
//  ttl     = 60
//}
//
//resource "aws_acm_certificate_validation" "ecs_example" {
//  certificate_arn         = aws_acm_certificate.ecs_example.arn
//  validation_record_fqdns = [aws_route53_record.ecs_example_certificate.fqdn]
//}

#####################
# ALB
#####################

resource "aws_lb" "ecs_example" {
  name                       = "ecs-example"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = true

  subnets = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id,
  ]

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id,
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecs_example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    //Respond to a fixed HTTP response
    fixed_response {
      content_type = "text/plain"
      message_body = "This is 「HTTP」！！"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ecs_example.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.ecs_example.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This is 「HTTPS」！！"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.ecs_example.arn
  port              = "8080"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#####################
# Log Bucket
#####################

resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-ecs-terraform"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

#####################
# Bucket Policy
#####################

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["582318560864"]
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

#####################
# Security Group
#####################

module "http_sg" {
  source      = "./security_group"
  name        = "http-sg"
  vpc_id      = aws_vpc.ecs_vpc.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source      = "./security_group"
  name        = "https-sg"
  vpc_id      = aws_vpc.ecs_vpc.id
  port        = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source      = "./security_group"
  name        = "http-redirect-sg"
  vpc_id      = aws_vpc.ecs_vpc.id
  port        = 8080
  cidr_blocks = ["0.0.0.0/0"]
}

#####################
# Route53
#####################

data "aws_route53_zone" "ecs-example" {
  name = "joegate.work"
}

resource "aws_route53_record" "ecs-example" {
  name    = data.aws_route53_zone.ecs-example.name
  type    = "A"
  zone_id = data.aws_route53_zone.ecs-example.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.ecs_example.dns_name
    zone_id                = aws_lb.ecs_example.zone_id
  }
}

#####################
# OutPut
#####################

output "alb_dns_name" {
  value = aws_lb.ecs_example.dns_name
}

output "domain_name" {
  value = aws_route53_record.ecs-example.name
}

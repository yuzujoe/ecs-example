#####################
# Outputs
#####################

output "aws_kms_arn" {
  value = aws_kms_key.ecs_example.arn
}

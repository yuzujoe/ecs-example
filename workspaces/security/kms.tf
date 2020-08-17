#####################
# KMS
#####################

resource "aws_kms_key" "ecs_example" {
  description             = "Example Customer Master Key"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "ecs_example" {
  target_key_id = aws_kms_key.ecs_example.key_id
  name          = "alias/ecs-example"
}

#####################
# SSM
#####################

resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  type        = "String"
  value       = "root"
  description = "database user name"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/db/password"
  type        = "SecureString"
  value       = "uninitialized"
  description = "database password"

  lifecycle {
    ignore_changes = [value]
  }
}

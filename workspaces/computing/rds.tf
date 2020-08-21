resource "aws_db_parameter_group" "ecs_example" {
  family = "mysql5.7"
  name   = "ecs-example"

  parameter {
    name  = "character_set_database"
    value = "uft8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

resource "aws_db_option_group" "ecs_example" {
  engine_name          = "mysql"
  major_engine_version = "5.7"
  name                 = "ecs-example"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

resource "aws_db_subnet_group" "ecs_example" {
  name = "ecs-example"

  subnet_ids = [
    data.terraform_remote_state.networking.outputs.aws_subnet_private_0,
    data.terraform_remote_state.networking.outputs.aws_subnet_private_1
  ]
}

resource "aws_db_instance" "ecs_example" {
  identifier                 = "ecs-example"
  engine                     = "mysql"
  engine_version             = "5.7.25"
  instance_class             = "db.t3.small"
  allocated_storage          = 20
  max_allocated_storage      = 100
  storage_type               = "gp2"
  storage_encrypted          = true
  kms_key_id                 = var.kms_key_arn
  username                   = "admin"
  password                   = "VeryStrongPassword!"
  multi_az                   = true
  publicly_accessible        = false
  backup_window              = "09:10-09:40"
  backup_retention_period    = 30
  maintenance_window         = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade = false
  deletion_protection        = true
  skip_final_snapshot        = false
  port                       = 3306
  apply_immediately          = false
  vpc_security_group_ids     = [module.mysql_sg.security_group_id]
  parameter_group_name       = aws_db_parameter_group.ecs_example.name
  option_group_name          = aws_db_option_group.ecs_example.name
  db_subnet_group_name       = aws_db_subnet_group.ecs_example.name

  lifecycle {
    ignore_changes = [password]
  }
}

module "mysql_sg" {
  source      = "../modules/security_group"
  name        = "mysql-sg"
  vpc_id      = data.terraform_remote_state.networking.outputs.aws_pvc
  port        = 3306
  cidr_blocks = [data.terraform_remote_state.networking.outputs.aws_vpc_cidr]
}

##########
# Redis
##########

resource "aws_elasticache_parameter_group" "ecs_example" {
  family = "redis5.0"
  name   = "ecs-example"

  parameter {
    name  = "cluster-enabled"
    value = "no"
  }
}

resource "aws_elasticache_subnet_group" "ecs_example" {
  name       = "ecs-example"
  subnet_ids = [
    data.terraform_remote_state.networking.outputs.aws_subnet_private_0,
    data.terraform_remote_state.networking.outputs.aws_subnet_private_1
  ]
}

resource "aws_elasticache_replication_group" "ecs_example" {
  replication_group_description = "Cluster Disabled"
  replication_group_id          = "ecs-example"
  engine                        = "redis"
  engine_version                = "5.0.4"
  number_cache_clusters         = 3
  node_type                     = "cache.m3.medium"
  snapshot_window               = "09:10-10:10"
  snapshot_retention_limit      = 7
  maintenance_window            = "mon:10:40-mon:11:40"
  automatic_failover_enabled    = true
  port                          = 6379
  apply_immediately             = false
  parameter_group_name          = aws_elasticache_parameter_group.ecs_example.name
  subnet_group_name             = aws_elasticache_subnet_group.ecs_example.name
  security_group_ids            = []
}

module "redis_sg" {
  source      = "../modules/security_group"
  name        = "redis-sg"
  vpc_id      = data.terraform_remote_state.networking.outputs.aws_pvc
  port        = 6739
  cidr_blocks = [data.terraform_remote_state.networking.outputs.aws_vpc_cidr]
}

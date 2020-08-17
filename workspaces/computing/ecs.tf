#####################
# ECS
#####################

resource "aws_ecs_cluster" "ecs_example" {
  name = "ecs-example"
}

resource "aws_ecs_task_definition" "ecs_example" {
  container_definitions    = file("./json_files/container_definitions.json")
  family                   = "ecs-example"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::273172227336:role/ecs-task-execution"
}

resource "aws_ecs_service" "ecs_example" {
  name                              = "ecs-example"
  task_definition                   = aws_ecs_task_definition.ecs_example.arn
  cluster                           = aws_ecs_cluster.ecs_example.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.nginx_sg.security_group_id]

    subnets = [
      data.aws_subnet.private_0.id,
      data.aws_subnet.private_1.id
    ]
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.ecs_example.arn
    container_name   = "ecs-example"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

#####################
# ECS Batch Task
#####################

resource "aws_ecs_task_definition" "ecs_example_batch" {
  container_definitions    = file("./json_files//batch_container_definitions.json")
  family                   = "ecs-example-batch"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::273172227336:role/ecs-task-execution"
}

#####################
# data
#####################

data "aws_subnet" "private_0" {
  id = "subnet-041c96ccf15f7e1fd"
}

data "aws_subnet" "private_1" {
  id = "subnet-0f4daa1f637cb7327"
}

data "aws_vpc" "ecs_example" {
  id         = "vpc-0e2282eecbc42fa40"
  cidr_block = "10.9.0.0/16"
}

data "aws_lb_target_group" "ecs_example" {
  arn = "arn:aws:elasticloadbalancing:ap-northeast-1:273172227336:targetgroup/ecs-example/30571b62061c6a3f"
}

#####################
# module
#####################

module "nginx_sg" {
  source      = "../networking/security_group"
  name        = "nginx-sg"
  vpc_id      = data.aws_vpc.ecs_example.id
  port        = 80
  cidr_blocks = [data.aws_vpc.ecs_example.cidr_block]
}

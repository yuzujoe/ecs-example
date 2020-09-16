#####################
# CloudWatch Logs
#####################

resource "aws_cloudwatch_log_group" "for_ecs" {
  name              = "/ecs/ecs-example"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
  name              = "/ecs-scheduled-tasks/ecs-example"
  retention_in_days = 30
}

resource "aws_cloudwatch_event_rule" "ecs_example_batch" {
  name                = "ecs-example-batch"
  description         = "This is most important batch job"
  schedule_expression = "cron(*/9 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "ecs_example_batch" {
  arn       = aws_ecs_cluster.ecs_example.arn
  rule      = aws_cloudwatch_event_rule.ecs_example_batch.name
  role_arn  = "arn:aws:iam::273172227336:role/ecs-events"
  target_id = "ecs-example-batch"

  ecs_target {
    task_definition_arn = aws_ecs_task_definition.ecs_example_batch.arn
    launch_type         = "FARGATE"
    task_count          = 1
    platform_version    = "1.4.0"

    network_configuration {
      assign_public_ip = false
      subnets          = [data.terraform_remote_state.networking.outputs.aws_subnet_private_0]
    }
  }
}

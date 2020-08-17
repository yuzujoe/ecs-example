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

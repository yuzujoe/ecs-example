#####################
# OutPuts
#####################

output "ecs_task_execution_role" {
  value = module.ecs_task_execution_role.iam_role_arn
}

output "ecs_event_role" {
  value = module.ecs_event_role.iam_role_arn
}

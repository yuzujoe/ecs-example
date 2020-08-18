########
# ECR
########

resource "aws_ecr_repository" "ecs_example" {
  name = "ecs-example"
}

resource "aws_ecr_lifecycle_policy" "ecs_example" {
  repository = aws_ecr_repository.ecs_example.name
  policy = jsonencode(
    {
      rules = [
        {
          action = {
            type = "expire"
          }
          rulePriority = 1
          description  = "Keep last 30 release tagged images."
          selection = {
            tagStatus     = "tagged"
            tagPrefixList = ["release"]
            countType     = "imageCountMoreThan"
            countNumber   = 30
          }
        }
      ]
    }
  )
}

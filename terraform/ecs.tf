resource "aws_ecs_cluster" "this" {
  name = "aws-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                = "task_definition"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = var.ecs.fargate_cpu
  memory                = var.ecs.fargate_memory
  container_definitions = jsonencode([{
    name  = "aws-ecs-container"
    image = "${aws_ecr_repository.this.repository_url}:latest"

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/aws-ecs"
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }

    portMappings = [{
      containerPort = var.ecs.app_port
      hostPort      = var.ecs.app_port
    }]
    environment = [
      {
        name  = "APP_NAME"
        value = "aws-ecs"
      },
      {
        name  = "PORT"
        value = tostring(var.ecs.app_port)
      },
      {
        name  = "LOG_LEVEL"
        value = var.log_level
      }
    ]
  }])
}

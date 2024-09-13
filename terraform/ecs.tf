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

resource "aws_ecs_service" "this" {
  name = "ecs-service"
  cluster = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count = 2
  launch_type = "FARGATE"
  health_check_grace_period_seconds = 30
  network_configuration {
    subnets = [ aws_subnet.ecs_sub_priv_1a.id, aws_subnet.ecs_sub_priv_1b.id ]
    security_groups = [ aws_security_group.ecs_tasks.id ]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.this.id
    container_name = "aws-ecs-container"
    container_port = var.ecs.app_port
  }
  depends_on = [ aws_alb_listener.http ]
  lifecycle {
    ignore_changes = [ desired_count ]
  }
}

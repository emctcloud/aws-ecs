resource "aws_ecs_cluster" "this" {
  name = "aws-ecs-cluster"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}
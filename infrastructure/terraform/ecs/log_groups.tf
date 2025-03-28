resource "aws_cloudwatch_log_group" "microservice_1" {
  name              = "/ecs/${var.environment}-microservice-1"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "microservice_2" {
  name              = "/ecs/${var.environment}-microservice-2"
  retention_in_days = 30
}

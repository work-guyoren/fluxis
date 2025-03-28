# ECS Service for Microservice 1
resource "aws_ecs_service" "microservice_1" {
  name            = "${var.environment}-microservice-1-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.microservice_1.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.ecs_task_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.microservice_1_target_group_arn
    container_name   = "microservice-1-container"
    container_port   = 5000
  }
}

# ECS Service for Microservice 2
resource "aws_ecs_service" "microservice_2" {
  name            = "${var.environment}-microservice-2-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.microservice_2.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.ecs_task_sg.id]
    assign_public_ip = true
  }

  tags = {
    Environment = var.environment
  }
}

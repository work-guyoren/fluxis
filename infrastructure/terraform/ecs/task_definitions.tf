# Task definition for Microservice 1
resource "aws_ecs_task_definition" "microservice_1" {
  family                   = "${var.environment}-microservice-1"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "microservice-1-container"
      image     = var.microservice_1_image
      memory    = 512
      cpu       = 256
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "QUEUE_URL", value = var.sqs_queue_url },
        { name = "TOKEN_PARAM_NAME", value = var.ssm_param_name }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.environment}-microservice-1"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "microservice_2" {
  family                   = "${var.environment}-microservice-2"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "microservice-2-container"
      image     = var.microservice_2_image
      memory    = 512
      cpu       = 256
      essential = true
      environment = [
        { name = "SQS_QUEUE_URL", value = var.sqs_queue_url },
        { name = "S3_BUCKET_NAME", value = var.s3_bucket_name },
        { name = "SSM_PARAM_NAME", value = var.ssm_param_name }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.environment}-microservice-2"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Environment = var.environment
  }
}

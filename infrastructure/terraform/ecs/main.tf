# Create an ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.environment}-ecs-cluster"

  tags = {
    Environment = var.environment
  }
}

# Create an IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# Attach the Amazon ECS Task Execution Role Policy to the IAM role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Security group for ECS tasks
resource "aws_security_group" "ecs_task_sg" {
  name        = "${var.environment}-ecs-task-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from anywhere (for testing purposes)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}
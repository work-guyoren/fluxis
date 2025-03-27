# Create an ECR repository for Microservice 1
resource "aws_ecr_repository" "microservice_1" {
  name = "${var.environment}-microservice-1"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
  }
}

# Create an ECR repository for Microservice 2
resource "aws_ecr_repository" "microservice_2" {
  name = "${var.environment}-microservice-2"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
  }
}
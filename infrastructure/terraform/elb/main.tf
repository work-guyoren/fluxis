# Revert to Application Load Balancer (ALB)
resource "aws_lb" "application_lb" {
  name               = "${var.environment}-application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Environment = var.environment
  }
}

# Update Security Group to allow requests from anywhere
resource "aws_security_group" "elb_sg" {
  name        = "${var.environment}-elb-sg"
  description = "Security group for the ELB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_inbound_cidr  # Allow traffic from specified CIDR blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Environment = var.environment
  }
}

# Update Target Group for Microservice 1
resource "aws_lb_target_group" "microservice_1_tg" {
  name        = "${var.environment}-microservice-1-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200" 
  }

  tags = {
    Environment = var.environment
  }
}

# Update Listener for Microservice 1
resource "aws_lb_listener" "microservice_1_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.microservice_1_tg.arn
  }
}
output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.application_lb.arn
}

output "microservice_1_target_group_arn" {
  description = "The ARN of the Target Group for Microservice 1"
  value       = aws_lb_target_group.microservice_1_tg.arn
}

output "microservice_2_target_group_arn" {
  description = "The ARN of the Target Group for Microservice 2"
  value       = aws_lb_target_group.microservice_2_tg.arn
}
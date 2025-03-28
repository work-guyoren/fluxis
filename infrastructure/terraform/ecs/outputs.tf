output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_sg_id" {
  description = "The ID of the security group for ECS tasks"
  value       = aws_security_group.ecs_task_sg.id
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "microservice_1_task_definition_arn" {
  description = "The ARN of the ECS task definition for Microservice 1"
  value       = aws_ecs_task_definition.microservice_1.arn
}

output "microservice_2_task_definition_arn" {
  description = "The ARN of the ECS task definition for Microservice 2"
  value       = aws_ecs_task_definition.microservice_2.arn
}

output "microservice_1_service_name" {
  description = "The name of the ECS service for Microservice 1"
  value       = aws_ecs_service.microservice_1.name
}

output "microservice_2_service_name" {
  description = "The name of the ECS service for Microservice 2"
  value       = aws_ecs_service.microservice_2.name
}
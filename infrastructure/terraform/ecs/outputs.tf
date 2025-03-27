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
  description = "The ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}
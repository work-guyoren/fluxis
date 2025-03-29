output "ssm_parameter_name" {
  description = "The name of the SSM parameter storing the token"
  value       = module.ssm.ssm_parameter_name
}

output "ssm_parameter_arn" {
  description = "The ARN of the SSM parameter storing the token"
  value       = module.ssm.ssm_parameter_arn
}

output "microservice_1_ecr_url" {
  description = "The ECR URL for Microservice 1"
  value       = module.ecr.microservice_1_repository_url
}

output "microservice_2_ecr_url" {
  description = "The ECR URL for Microservice 2"
  value       = module.ecr.microservice_2_repository_url
}

output "sqs_queue_url" {
  description = "The URL of the main SQS queue"
  value       = module.sqs.main_queue_url
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "ecs_cluster_id" {
  description = "The ECS cluster id"
  value = module.ecs.ecs_cluster_id
}

output "microservice_1_task_definition_arn" {
  description = "The ARN of the ECS task definition for Microservice 1"
  value       = module.ecs.microservice_1_task_definition_arn
}

output "microservice_2_task_definition_arn" {
  description = "The ARN of the ECS task definition for Microservice 2"
  value       = module.ecs.microservice_2_task_definition_arn
}

output "microservice_1_service_name" {
  description = "The name of the ECS service for Microservice 1"
  value       = module.ecs.microservice_1_service_name
}

output "microservice_2_service_name" {
  description = "The name of the ECS service for Microservice 2"
  value       = module.ecs.microservice_2_service_name
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.elb.alb_dns_name
}

output "cloudwatch_dashboard_name" {
  description = "The name of the CloudWatch dashboard for microservices"
  value       = module.monitoring.dashboard_name
}

output "cloudwatch_dashboard_url" {
  description = "The URL to access the CloudWatch dashboard"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${module.monitoring.dashboard_name}"
}

output "alarm_arns" {
  description = "All CloudWatch alarm ARNs"
  value = {
    # ECS alarms
    microservice_1_cpu = module.monitoring.microservice_1_cpu_alarm_arn
    microservice_1_memory = module.monitoring.microservice_1_memory_alarm_arn
    microservice_2_cpu = module.monitoring.microservice_2_cpu_alarm_arn
    microservice_2_memory = module.monitoring.microservice_2_memory_alarm_arn
    
    # SQS alarms
    sqs_queue_depth = module.monitoring.sqs_queue_depth_alarm_arn
    sqs_message_age = module.monitoring.sqs_message_age_alarm_arn
    dlq_messages = module.monitoring.dlq_messages_alarm_arn
    
    # ALB alarms
    alb_5xx_errors = module.monitoring.alb_5xx_error_alarm_arn
  }
}
output "dashboard_name" {
  description = "The name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.microservices_dashboard.dashboard_name
}

output "dashboard_arn" {
  description = "The ARN of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.microservices_dashboard.dashboard_arn
}

output "microservice_1_cpu_alarm_arn" {
  description = "The ARN of the Microservice 1 CPU alarm"
  value       = aws_cloudwatch_metric_alarm.microservice_1_cpu_alarm.arn
}

output "microservice_1_memory_alarm_arn" {
  description = "The ARN of the Microservice 1 memory alarm"
  value       = aws_cloudwatch_metric_alarm.microservice_1_memory_alarm.arn
}

output "microservice_2_cpu_alarm_arn" {
  description = "The ARN of the Microservice 2 CPU alarm"
  value       = aws_cloudwatch_metric_alarm.microservice_2_cpu_alarm.arn
}

output "microservice_2_memory_alarm_arn" {
  description = "The ARN of the Microservice 2 memory alarm"
  value       = aws_cloudwatch_metric_alarm.microservice_2_memory_alarm.arn
}

output "sqs_queue_depth_alarm_arn" {
  description = "The ARN of the SQS queue depth alarm"
  value       = aws_cloudwatch_metric_alarm.sqs_queue_depth_alarm.arn
}

output "sqs_message_age_alarm_arn" {
  description = "The ARN of the SQS message age alarm"
  value       = aws_cloudwatch_metric_alarm.sqs_message_age_alarm.arn
}

output "dlq_messages_alarm_arn" {
  description = "The ARN of the DLQ messages alarm"
  value       = aws_cloudwatch_metric_alarm.dlq_messages_alarm.arn
}

output "alb_5xx_error_alarm_arn" {
  description = "The ARN of the ALB 5XX error alarm"
  value       = aws_cloudwatch_metric_alarm.alb_5xx_error_alarm.arn
}

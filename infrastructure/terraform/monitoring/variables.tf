variable "environment" {
  description = "The environment for the dashboard (e.g., dev, prod)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources are located"
  type        = string
  default     = "us-east-2"
}

variable "alb_arn_suffix" {
  description = "The ARN suffix of the ALB"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "The ARN suffix of the target group"
  type        = string
}

variable "sqs_queue_name" {
  description = "The name of the SQS queue"
  type        = string
}

variable "dlq_name" {
  description = "The name of the Dead Letter Queue"
  type        = string
  default     = "" # This will be a default empty string if not provided
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket created by Terraform"
  type        = string
}

variable "alarm_actions" {
  description = "List of ARNs to notify when the alarm transitions to ALARM state"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "List of ARNs to notify when the alarm transitions to OK state"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "The environment for the ECS cluster (dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the ECS cluster will be deployed"
  type        = string
}

variable "subnets" {
  description = "The list of public subnets for ECS tasks"
  type        = list(string)
}

variable "elb_security_group_id" {
  description = "The security group ID of the ELB"
  type        = string
}

variable "microservice_1_image" {
  description = "The Docker image for Microservice 1"
  type        = string
}

variable "microservice_2_image" {
  description = "The Docker image for Microservice 2"
  type        = string
}

variable "sqs_queue_url" {
  description = "The URL of the SQS queue"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "ssm_param_name" {
  description = "The name of the SSM parameter for the token"
  type        = string
}

variable "microservice_1_target_group_arn" {
  description = "The ARN of the target group for Microservice 1"
  type        = string
}
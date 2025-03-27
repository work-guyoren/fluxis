variable "token_value" {
  description = "The token value to store in SSM Parameter Store"
  type        = string
  sensitive   = true
  default     = null
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "The VPC ID where the resources will be deployed"
  type        = string
}

variable "subnets" {
  description = "The list of public subnets for the resources"
  type        = list(string)
}

variable "allowed_inbound_cidr" {
  description = "The CIDR block allowed to access the ALB (e.g., 0.0.0.0/0 for public access)"
  type        = string
  default     = "0.0.0.0/0"
}
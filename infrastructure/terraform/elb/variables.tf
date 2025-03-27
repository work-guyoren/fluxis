variable "environment" {
  description = "The environment for the infrastructure (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed"
  type        = string
}

variable "subnets" {
  description = "The list of public subnets for the ALB"
  type        = list(string)
}

variable "elb_security_group_id" {
  description = "The security group ID for the ALB"
  type        = string
}

variable "allowed_inbound_cidr" {
  description = "The CIDR block allowed to access the ALB (e.g., 0.0.0.0/0 for public access)"
  type        = string
  default     = "0.0.0.0/0"
}
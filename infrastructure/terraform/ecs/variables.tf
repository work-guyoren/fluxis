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
variable "token_value" {
  description = "The token value to store in SSM Parameter Store"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "The environment for the SSM parameter (e.g., dev, prod)"
  type        = string
}
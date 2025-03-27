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

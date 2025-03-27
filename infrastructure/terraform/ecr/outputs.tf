output "microservice_1_repository_url" {
  description = "The URL of the ECR repository for Microservice 1"
  value       = aws_ecr_repository.microservice_1.repository_url
}

output "microservice_2_repository_url" {
  description = "The URL of the ECR repository for Microservice 2"
  value       = aws_ecr_repository.microservice_2.repository_url
}
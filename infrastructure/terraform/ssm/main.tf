# Create an SSM Parameter to store the token
resource "aws_ssm_parameter" "token" {
  name        = "${var.environment}-token"
  description = "Token for Microservice authentication"
  type        = "SecureString"
  value       = var.token_value  # Ensure this is the only value-related attribute

  tags = {
    Environment = var.environment
  }
}
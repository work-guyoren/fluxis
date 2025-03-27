# Create an SQS queue
resource "aws_sqs_queue" "main_queue" {
  name = "${var.environment}-main-queue"

  # Optional: Configure SQS queue settings
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
  delay_seconds              = 0

  tags = {
    Environment = var.environment
  }
}

# (Optional) Create a dead-letter queue (DLQ)
resource "aws_sqs_queue" "dead_letter_queue" {
  name = "${var.environment}-dlq"

  # Optional: Configure DLQ settings
  message_retention_seconds = 1209600 # 14 days

  tags = {
    Environment = var.environment
  }
}

# Attach the DLQ to the main queue
resource "aws_sqs_queue_policy" "main_queue_policy" {
  queue_url = aws_sqs_queue.main_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowDeadLetterQueue"
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.dead_letter_queue.arn
      }
    ]
  })
}
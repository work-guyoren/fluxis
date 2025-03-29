resource "aws_cloudwatch_dashboard" "microservices_dashboard" {
  dashboard_name = "${var.environment}-microservices-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      # ECS Service Metrics - Microservice 1
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", "${var.environment}-microservice-1-service", "ClusterName", "${var.environment}-ecs-cluster", { "stat" = "Average" }],
            ["AWS/ECS", "MemoryUtilization", "ServiceName", "${var.environment}-microservice-1-service", "ClusterName", "${var.environment}-ecs-cluster", { "stat" = "Average" }]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "Microservice 1 - CPU and Memory Utilization",
          period  = 300
        }
      },
      # ECS Service Metrics - Microservice 2
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", "${var.environment}-microservice-2-service", "ClusterName", "${var.environment}-ecs-cluster", { "stat" = "Average" }],
            ["AWS/ECS", "MemoryUtilization", "ServiceName", "${var.environment}-microservice-2-service", "ClusterName", "${var.environment}-ecs-cluster", { "stat" = "Average" }]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "Microservice 2 - CPU and Memory Utilization",
          period  = 300
        }
      },
      # SQS Queue Metrics - Use the exact queue name from Terraform module
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/SQS", "NumberOfMessagesReceived", "QueueName", var.sqs_queue_name, { "stat" = "Sum" }],
            ["AWS/SQS", "NumberOfMessagesDeleted", "QueueName", var.sqs_queue_name, { "stat" = "Sum" }],
            ["AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", var.sqs_queue_name, { "stat" = "Average" }]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "SQS Queue Metrics",
          period  = 300
        }
      },
      # ALB Key Performance Metrics
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Sum", "label": "Request Count" }],
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Average", "label": "Avg Response Time" }],
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix, { "stat" = "p90", "label": "p90 Response Time" }],
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix, { "stat" = "p99", "label": "p99 Response Time" }]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "ALB Performance Metrics",
          period  = 300
        }
      },
      # ALB Connection Metrics
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "ActiveConnectionCount", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Sum" }],
            ["AWS/ApplicationELB", "NewConnectionCount", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Sum" }],
            ["AWS/ApplicationELB", "RejectedConnectionCount", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Sum" }]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "ALB Connection Metrics",
          period  = 300
        }
      },
      # ALB Processing Metrics
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "ProcessedBytes", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Sum" }],
            ["AWS/ApplicationELB", "ConsumedLCUs", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Sum" }]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "ALB Processing Metrics",
          period  = 300
        }
      },
      # SQS Queue Additional Metrics
      {
        type   = "metric"
        x      = 0
        y      = 18
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", var.sqs_queue_name, { "stat" = "Maximum" }],
            ["AWS/SQS", "ApproximateNumberOfMessagesNotVisible", "QueueName", var.sqs_queue_name, { "stat" = "Average" }],
            ["AWS/SQS", "NumberOfMessagesSent", "QueueName", var.sqs_queue_name, { "stat" = "Sum" }]
          ],
          view    = "timeSeries", 
          stacked = false,
          region  = var.aws_region,
          title   = "SQS Queue Additional Metrics",
          period  = 300
        }
      },
      # ALB Errors (HTTP 4xx, 5xx)
      {
        type   = "metric"
        x      = 12
        y      = 18
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Sum" }],
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Sum" }],
            ["AWS/ApplicationELB", "HTTPCode_ELB_4XX_Count", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Sum" }],
            ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", var.alb_arn_suffix, { "stat" = "Sum" }]
          ],
          view    = "timeSeries",
          stacked = true,
          region  = var.aws_region,
          title   = "ALB Error Codes",
          period  = 300
        }
      },
      # Target Group Health
      {
        type   = "metric"
        x      = 0
        y      = 24
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix, { "stat" = "Average" }],
            ["AWS/ApplicationELB", "UnHealthyHostCount", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix, { "stat" = "Average" }]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "Target Group Health",
          period  = 60
        }
      },
      # Dead Letter Queue Metrics
      {
        type   = "metric"
        x      = 12
        y      = 24
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", var.dlq_name, { "stat" = "Average", "label": "DLQ Messages" }]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "Dead Letter Queue Messages",
          period  = 300
        }
      },
      # S3 Bucket Metrics
      {
        type   = "metric"
        x      = 0
        y      = 30
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/S3", "NumberOfObjects", "BucketName", var.s3_bucket_name, "StorageType", "AllStorageTypes", { "stat" = "Average", "label": "Total Objects" }]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "S3 Bucket Object Count",
          period  = 86400  # Daily metric for S3 object count
        }
      },
      # S3 Bucket Storage Metrics
      {
        type   = "metric"
        x      = 12
        y      = 30
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/S3", "BucketSizeBytes", "BucketName", var.s3_bucket_name, "StorageType", "StandardStorage", { "stat" = "Average", "label": "Standard Storage (Bytes)" }],
            ["AWS/S3", "BucketSizeBytes", "BucketName", var.s3_bucket_name, "StorageType", "AllStorageTypes", { "stat" = "Average", "label": "Total Storage (Bytes)" }]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "S3 Bucket Size",
          period  = 86400  # Daily metric for S3 storage
        }
      }
    ]
  })
}

# CPU Utilization Alarm for Microservice 1
resource "aws_cloudwatch_metric_alarm" "microservice_1_cpu_alarm" {
  alarm_name          = "${var.environment}-microservice-1-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors Microservice 1 CPU utilization"
  
  dimensions = {
    ClusterName = "${var.environment}-ecs-cluster"
    ServiceName = "${var.environment}-microservice-1-service"
  }
  
  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

# Memory Utilization Alarm for Microservice 1
resource "aws_cloudwatch_metric_alarm" "microservice_1_memory_alarm" {
  alarm_name          = "${var.environment}-microservice-1-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors Microservice 1 memory utilization"
  
  dimensions = {
    ClusterName = "${var.environment}-ecs-cluster"
    ServiceName = "${var.environment}-microservice-1-service"
  }
  
  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

# CPU Utilization Alarm for Microservice 2
resource "aws_cloudwatch_metric_alarm" "microservice_2_cpu_alarm" {
  alarm_name          = "${var.environment}-microservice-2-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors Microservice 2 CPU utilization"
  
  dimensions = {
    ClusterName = "${var.environment}-ecs-cluster"
    ServiceName = "${var.environment}-microservice-2-service"
  }
  
  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

# Memory Utilization Alarm for Microservice 2
resource "aws_cloudwatch_metric_alarm" "microservice_2_memory_alarm" {
  alarm_name          = "${var.environment}-microservice-2-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors Microservice 2 memory utilization"
  
  dimensions = {
    ClusterName = "${var.environment}-ecs-cluster"
    ServiceName = "${var.environment}-microservice-2-service"
  }
  
  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

# SQS Queue Depth Alarm
resource "aws_cloudwatch_metric_alarm" "sqs_queue_depth_alarm" {
  alarm_name          = "${var.environment}-sqs-queue-depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Average"
  threshold           = 100
  alarm_description   = "This metric monitors SQS queue depth"
  
  dimensions = {
    QueueName = var.sqs_queue_name
  }
  
  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

# SQS Message Age Alarm (catches stuck messages)
resource "aws_cloudwatch_metric_alarm" "sqs_message_age_alarm" {
  alarm_name          = "${var.environment}-sqs-message-age"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Maximum"
  threshold           = 3600 # 1 hour in seconds
  alarm_description   = "This metric monitors the age of the oldest message in the queue"
  
  dimensions = {
    QueueName = var.sqs_queue_name
  }
  
  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

# DLQ Message Count Alarm
resource "aws_cloudwatch_metric_alarm" "dlq_messages_alarm" {
  alarm_name          = "${var.environment}-dlq-messages"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  treat_missing_data  = "notBreaching"
  alarm_description   = "This metric detects messages in the Dead Letter Queue"
  
  dimensions = {
    QueueName = var.dlq_name
  }
  
  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

# ALB 5XX Error Rate Alarm
resource "aws_cloudwatch_metric_alarm" "alb_5xx_error_alarm" {
  alarm_name          = "${var.environment}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "This metric monitors ALB 5XX errors"
  
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }
  
  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

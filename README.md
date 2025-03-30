# Fluxis

Fluxis is a microservice-based application deployed on AWS using Terraform for infrastructure and GitHub Actions for CI/CD. It consists of two microservices that communicate through AWS SQS and store data in S3.

## Project Components

### Infrastructure (Terraform)

The infrastructure is defined using Terraform modules:

- **ECS**: Manages the ECS cluster, services, and task definitions for the microservices
- **ECR**: Container registries for both microservices
- **S3**: Storage bucket for microservice-2 outputs
- **SQS**: Message queue for communication between microservices
- **SSM**: Parameter store for secure token storage
- **ELB**: Application Load Balancer for routing traffic to microservice-1

### CI/CD Pipeline (GitHub Actions)

The CI/CD pipeline consists of three workflows:

1. **CI Workflow**: Builds, tests, and pushes Docker images to ECR
   - Runs unit tests for both microservices
   - Builds Docker images with proper tags
   - Pushes images to ECR repositories

2. **CD Workflow**: Deploys services to ECS
   - Updates ECS services to use the latest container images
   - Forces new deployments

3. **Main Pipeline**: Orchestrates CI and CD workflows
   - Runs on pushes to the main branch
   - Can be manually triggered to deploy to specific environments

## Project Setup Guide

### Prerequisites

- AWS CLI installed and configured with appropriate credentials
- Terraform installed (v1.0.0+)
- Git

### Setting Up the Infrastructure

1. **Create Backend Resources**

   Before applying Terraform, create the required S3 bucket and DynamoDB table for remote state management:

   ```bash
   # Export the bucket name for use in commands
   export TF_BUCKET=dev-100-terraform-state
   
   # Create S3 bucket
   aws s3api create-bucket \
     --bucket $TF_BUCKET \
     --region us-east-2 \
     --create-bucket-configuration LocationConstraint=us-east-2
   
   # Enable versioning
   aws s3api put-bucket-versioning \
     --bucket $TF_BUCKET \
     --versioning-configuration Status=Enabled
   
   # Enable encryption
   aws s3api put-bucket-encryption \
     --bucket $TF_BUCKET \
     --server-side-encryption-configuration \
     '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
   
   # Create DynamoDB table for state locking
   aws dynamodb create-table \
     --table-name terraform-locks \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PROVISIONED \
     --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
     --region us-east-2
   ```

2. **Configure Required Variables**

   Export variables:

   ```bash
   # Export required variables
   export TF_VAR_token_value="your-secure-token"
   export TF_VAR_environment="dev"
   export TF_VAR_vpc_id="vpc-xxxxxxxx"
   export TF_VAR_subnets='["subnet-xxxxxxxx", "subnet-yyyyyyyy"]'
   ```

3. **Initialize and Apply Terraform**

   ```bash
   cd infrastructure/terraform
   terraform init
   terraform plan
   terraform apply
   ```

4. **Verify Resources**

   ```bash
   terraform output
   ```

### Setting Up CI/CD

1. **Add Repository Secrets in GitHub**

   - AWS_ACCESS_KEY_ID
   - AWS_SECRET_ACCESS_KEY

2. **Push to Main Branch**

   - Pushing to main will trigger the CI/CD pipeline
   - Alternatively, use the manual workflow dispatch to deploy to a specific environment

## Microservices

- **Microservice-1**: RESTful API that validates inputs and sends messages to SQS
- **Microservice-2**: Background worker that processes SQS messages and stores them in S3

## Monitoring

The application includes CloudWatch monitoring for observability:

- **CloudWatch Dashboard**: Provides metrics visualization for both microservices
- **Alarms**: Configured for high CPU usage and SQS message age thresholds
- **Logs**: All microservice logs are sent to CloudWatch Log groups

To access the CloudWatch dashboard:

```bash
# Get the dashboard URL from Terraform output
DASHBOARD_URL=$(terraform output -raw cloudwatch_dashboard_url)

# Or navigate directly in AWS Console
echo "Navigate to: https://console.aws.amazon.com/cloudwatch/home?region=us-east-2#dashboards:name=fluxis-${TF_VAR_environment}-dashboard"
```

## Triggering Microservices via ALB

To test the microservices after deployment, you can send a request to Microservice-1 via the Application Load Balancer:

```bash
# Replace <ALB-DNS-URL> with your actual ALB DNS name from terraform output
# This request includes the authentication token from your environment variables

curl -X POST http://<ALB-DNS-URL> \
  -H "Content-Type: application/json" \
  -d '{
    "token": "'"$TF_VAR_token_value"'",
    "data": {
      "email_subject": "Happy new year!",
      "email_sender": "John Doe",
      "email_timestream": "1693561101",
      "email_content": "Just want to say... Happy new year!!!"
    }
  }'
```

Field descriptions:
- `email_subject`: The subject line of the email
- `email_sender`: The name of the person or entity sending the email
- `email_timestream`: A timestamp (in Unix format) indicating when the email was created
- `email_content`: The body content of the email message
- `token`: A secure token used for authentication (should match the one in SSM)

## Development

For local development, use the provided `.env.test` file to run tests:

```bash
cd microservice-1
python -m unittest discover -s tests

cd ../microservice-2
python -m unittest discover -s tests
```

## Environments

The infrastructure supports multiple environments (dev, staging, prod) through the `environment` variable.


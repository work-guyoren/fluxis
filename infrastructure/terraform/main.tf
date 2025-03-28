terraform {
  backend "s3" {
    bucket         = "dev-100-terraform-state"
    key            = "terraform/state.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "s3" {
  source      = "./s3"
  environment = var.environment
  ecs_task_role_arn = module.ecs.ecs_task_role_arn
}

module "sqs" {
  source      = "./sqs"
  environment = var.environment
}

module "elb" {
  source                = "./elb"
  environment           = var.environment
  vpc_id                = var.vpc_id
  subnets               = var.subnets
  allowed_inbound_cidr  = var.allowed_inbound_cidr
}

module "ecs" {
  source                = "./ecs"
  environment           = var.environment
  vpc_id                = var.vpc_id
  subnets               = var.subnets
  elb_security_group_id = module.elb.elb_sg_id
  microservice_1_image          = module.ecr.microservice_1_repository_url
  microservice_2_image          = module.ecr.microservice_2_repository_url
  sqs_queue_url                 = module.sqs.main_queue_url
  s3_bucket_name                = module.s3.bucket_name
  ssm_param_name                = module.ssm.ssm_parameter_name
  microservice_1_target_group_arn = module.elb.microservice_1_target_group_arn
}

module "ssm" {
  source      = "./ssm"
  environment = var.environment
  token_value = var.token_value
}

module "ecr" {
  source      = "./ecr"
  environment = var.environment
}
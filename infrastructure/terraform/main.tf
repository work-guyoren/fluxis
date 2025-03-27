terraform {
  backend "s3" {
    bucket         = "dev-100-terraform-state"
    key            = "terraform/state.tfstate"
    region         = "us-east-2"
    encrypt        = true
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
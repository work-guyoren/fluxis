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
}

module "sqs" {
  source      = "./sqs"
  environment = var.environment
}

module "ecs" {
  source      = "./ecs"
  environment = var.environment
  vpc_id      = var.vpc_id
  subnets     = var.subnets
}

module "elb" {
  source                = "./elb"
  environment           = var.environment
  vpc_id                = var.vpc_id
  subnets               = var.subnets
  elb_security_group_id = module.ecs.ecs_task_sg_id
  allowed_inbound_cidr  = var.allowed_inbound_cidr
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
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    random = {
      source = "hashicorp/random"
    }
  }
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

################################
# NETWORK AUTO-TRIGGER LOGIC
################################

locals {
  needs_network = (
    contains(var.services_to_deploy, "ec2") ||
    contains(var.services_to_deploy, "eks") ||
    contains(var.services_to_deploy, "ecs") ||
    #contains(var.services_to_deploy, "lambda") ||  #enable if lambda should be created in vpc
    contains(var.services_to_deploy, "rds") ||
    #contains(var.services_to_deploy, "opensearch") ||
    contains(var.services_to_deploy, "redshift")
  )
}

################################
# VPC MODULE
################################

module "vpc" {
  source   = "./modules/vpc"
  for_each = local.needs_network ? { network = true } : {}

  vpc_cidr_block = var.vpc_cidr_block

}

################################
# EC2 MODULE
################################

module "ec2" {
  source   = "./modules/ec2"
  for_each = contains(var.services_to_deploy, "ec2") ? { ec2 = true } : {}

  ec2_name = "tf-${terraform.workspace}-ec2-${random_string.suffix.result}"
  sg_name = "tf-${terraform.workspace}-sg-${random_string.suffix.result}"
  subnet_ids     = module.vpc["network"].public_subnet_ids
  ami            = var.ec2_ami
  instance_type  = var.ec2_instance_type
  key_name       = var.key_name
  instance_count = var.ec2_instance_count
}

################################
# EKS MODULE
################################

module "eks" {
  source   = "./modules/eks"
  for_each = contains(var.services_to_deploy, "eks") ? { eks = true } : {}

  name       = "tf-${terraform.workspace}-eks-${random_string.suffix.result}"
  vpc_id     = module.vpc["network"].vpc_id
  subnet_ids = module.vpc["network"].public_subnet_ids
}

################################
# S3 MODULE
################################

module "s3" {
  source   = "./modules/s3"
  for_each = contains(var.services_to_deploy, "s3") ? { s3 = true } : {}

  bucket_prefix = var.s3_bucket_prefix

}

################################
# RDS MODULE
################################

module "rds" {
  source   = "./modules/rds"
  for_each = contains(var.services_to_deploy, "rds") ? { rds = true } : {}

  vpc_id             = module.vpc["network"].vpc_id
  private_subnet_ids = module.vpc["network"].public_subnet_ids
  db_username        = var.rds_db_username
  db_password        = var.rds_db_password
  rds_engine         = var.rds_engine
}

################################
# LAMBDA MODULE
################################

module "lambda" {
  source   = "./modules/lambda"
  for_each = contains(var.services_to_deploy, "lambda") ? { lambda = true } : {}

  lambda_role_arn = var.lambda_role_arn
  runtime         = var.lambda_runtime
  handler         = var.lambda_handler
}

################################
# ECR MODULE
################################

module "ecr" {
  source   = "./modules/ecr"
  ecr_name = "tf-${terraform.workspace}-ecr-${random_string.suffix.result}"
  for_each = contains(var.services_to_deploy, "ecr") ? { ecr = true } : {}


}


################################
# SNS MODULE
################################

module "sns" {
  source   = "./modules/sns"
  for_each = contains(var.services_to_deploy, "sns") ? { sns = true } : {}
}


################################
# DevOps MODULE
################################
module "codecommit" {
  source   = "./modules/devops/codecommit"
  for_each = contains(var.services_to_deploy, "codecommit") ? { codecommit = true } : {}
}

module "codebuild" {
  source          = "./modules/devops/codebuild"
  for_each        = contains(var.services_to_deploy, "codebuild") ? { codebuild = true } : {}
  repository_name = module.codecommit["codecommit"].repository_name
}

module "codepipeline" {
  source             = "./modules/devops/codepipeline"
  for_each           = contains(var.services_to_deploy, "codepipeline") ? { codepipeline = true } : {}
  repository_name    = module.codecommit["codecommit"].repository_name
  build_project_name = module.codebuild["codebuild"].project_name
}

################################
# GLUE MODULE
################################

module "glue" {
  source   = "./modules/glue"
  for_each = contains(var.services_to_deploy, "glue") ? { glue = true } : {}  
  s3_bucket = "tf-${terraform.workspace}-s3-${random_string.suffix.result}"
  iam_role = "tf-${terraform.workspace}-gluerole-${random_string.suffix.result}"
  iam_policy = "tf-${terraform.workspace}-gluepolicy-${random_string.suffix.result}"
  catalog = "tf-${terraform.workspace}-catalog-${random_string.suffix.result}"
  crawler = "tf-${terraform.workspace}-crawler-${random_string.suffix.result}"
  job = "tf-${terraform.workspace}-job-${random_string.suffix.result}"
}

################################
# Opensearch MODULE
################################

module "opensearch" {
  source        = "./modules/opensearch"
  for_each      = contains(var.services_to_deploy, "opensearch") ? { opensearch = true } : {}
  instance_type = var.opensearh_instance_type
  region        = var.aws_region
}

################################
# Sagemaker MODULE
################################


module "sagemaker" {
  source                 = "./modules/sagemaker"
  for_each               = contains(var.services_to_deploy, "sagemaker") ? { sagemaker = true } : {}
  notebook_instance_type = var.notebook_instance_type
}

################################
# Quicksight MODULE
################################

module "quicksight" {
  source   = "./modules/quicksight"
  for_each = contains(var.services_to_deploy, "quicksight") ? { quicksight = true } : {}
}


################################
# REDSHIFT MODULE
################################

module "redshift" {
  source   = "./modules/redshift"
  for_each = contains(var.services_to_deploy, "redshift") ? { redshift = true } : {}

  vpc_id     = module.vpc["network"].vpc_id
  subnet_ids = module.vpc["network"].public_subnet_ids

  master_username = var.redshift_master_username
  master_password = var.redshift_master_password

  allowed_cidr_blocks = [var.vpc_cidr_block]
}



################################
# ECS MODULE
################################


module "ecs" {
  source   = "./modules/ecs"
  for_each = contains(var.services_to_deploy, "ecs") ? { ecs = true } : {}
  ecs_name = "tf-${terraform.workspace}-ecs-${random_string.suffix.result}"

  ##use the following when creating task definition or service
  # vpc_id          = module.vpc["network"].vpc_id
  # subnet_ids      = module.vpc["network"].public_subnet_ids
  # container_image = var.ecs_container_image
  # container_port  = 80    
}


################################
# SQS MODULE
################################

module "sqs" {
  source   = "./modules/sqs"
  for_each = contains(var.services_to_deploy, "sqs") ? { sqs = true } : {}

  queue_name                 = var.sqs_queue_name
  delay_seconds              = var.sqs_delay_seconds
  max_message_size           = var.sqs_max_message_size
  message_retention_seconds  = var.sqs_message_retention_seconds
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
}


################################
# API GATEWAY MODULE
################################

module "apigw" {
  source = "./modules/apigw"
  name = "tf-${terraform.workspace}-apigw-${random_string.suffix.result}"
  count = contains(var.services_to_deploy, "apigw") ? var.apigw_count : 0


}


################################
# BEDROCK AGENT
################################

module "bedrock_agent" {
  source   = "./modules/bedrock/agent"
  agent_name = "tf-${terraform.workspace}-br-${random_string.suffix.result}"
  for_each = contains(var.services_to_deploy, "bedrock-agent") ? { agent = true } : {}
}


################################
# BEDROCK KNOWLEDGE BASE
################################

module "bedrock_kb" {
  source   = "./modules/bedrock/knowledgebase"
  kb_name = "tf-${terraform.workspace}-kb-${random_string.suffix.result}"
  for_each = contains(var.services_to_deploy, "bedrock-kb") ? { kb = true } : {}
}
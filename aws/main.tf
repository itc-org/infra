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

locals {
  name = "tf-${terraform.workspace}"
}

# ─────────────────────────────────────────────────────────────────────────────
# Pattern: every service has an  <svc>_enabled  boolean and (where it can scale)
# a map variable. Turn a service on with the boolean; add a map key to create
# another instance, then re-run the pipeline.
#
# Scales via map keys today (modules take a name):
#   ec2, eks, ecr, ecs, glue, sqs, apigw, bedrock_agent, bedrock_kb, s3
# Single instance per map key but module names resources internally — adding a
# 2nd key needs a one-line `name` input in the module to avoid clashes:
#   rds, redshift, lambda, sns, opensearch, sagemaker
# ─────────────────────────────────────────────────────────────────────────────

################################
# VPC MODULE  (shared network)
################################
module "vpc" {
  source   = "./modules/vpc"
  for_each = var.vpc_enabled ? { network = true } : {}

  vpc_cidr_block = var.vpc_cidr_block
}

################################
# EC2 MODULE
################################
module "ec2" {
  source   = "./modules/ec2"
  for_each = var.ec2_enabled ? var.ec2_instances : {}

  ec2_name       = "${local.name}-ec2-${each.key}-${random_string.suffix.result}"
  sg_name        = "${local.name}-sg-${each.key}-${random_string.suffix.result}"
  subnet_ids     = module.vpc["network"].public_subnet_ids
  ami            = each.value.ami
  instance_type  = each.value.instance_type
  key_name       = each.value.key_name
  instance_count = each.value.instance_count
}

################################
# EKS MODULE
################################
module "eks" {
  source   = "./modules/eks"
  for_each = var.eks_enabled ? var.eks_clusters : {}

  name       = "${local.name}-eks-${each.key}-${random_string.suffix.result}"
  vpc_id     = module.vpc["network"].vpc_id
  subnet_ids = module.vpc["network"].public_subnet_ids # public subnets

  instance_type = each.value.instance_type
  desired_size  = each.value.desired_size
  min_size      = each.value.min_size
  max_size      = each.value.max_size
}

################################
# S3 MODULE
################################
module "s3" {
  source   = "./modules/s3"
  for_each = var.s3_enabled ? var.s3_buckets : {}

  bucket_prefix = each.value.bucket_prefix
}

################################
# RDS MODULE
################################
module "rds" {
  source   = "./modules/rds"
  for_each = var.rds_enabled ? var.rds_instances : {}

  vpc_id             = module.vpc["network"].vpc_id
  private_subnet_ids = module.vpc["network"].public_subnet_ids
  db_username        = each.value.db_username
  db_password        = each.value.db_password
  rds_engine         = each.value.engine
}

################################
# REDSHIFT MODULE
################################
module "redshift" {
  source   = "./modules/redshift"
  for_each = var.redshift_enabled ? var.redshift_clusters : {}

  vpc_id     = module.vpc["network"].vpc_id
  subnet_ids = module.vpc["network"].public_subnet_ids

  master_username = each.value.master_username
  master_password = each.value.master_password
  node_type       = each.value.node_type
  cluster_type    = each.value.cluster_type
  number_of_nodes = each.value.number_of_nodes

  allowed_cidr_blocks = [var.vpc_cidr_block]
}

################################
# LAMBDA MODULE
################################
module "lambda" {
  source   = "./modules/lambda"
  for_each = var.lambda_enabled ? var.lambda_functions : {}

  lambda_role_arn = each.value.role_arn
  runtime         = each.value.runtime
  handler         = each.value.handler
}

################################
# ECR MODULE
################################
module "ecr" {
  source   = "./modules/ecr"
  for_each = var.ecr_enabled ? var.ecr_repos : {}

  ecr_name = "${local.name}-ecr-${each.key}-${random_string.suffix.result}"
}

################################
# SNS MODULE
################################
module "sns" {
  source   = "./modules/sns"
  for_each = var.sns_enabled ? var.sns_topics : {}
}

################################
# DevOps MODULE  (single chain)
################################
module "codecommit" {
  source   = "./modules/devops/codecommit"
  for_each = var.codecommit_enabled ? { this = true } : {}
}

module "codebuild" {
  source          = "./modules/devops/codebuild"
  for_each        = var.codebuild_enabled ? { this = true } : {}
  repository_name = module.codecommit["this"].repository_name
}

module "codepipeline" {
  source             = "./modules/devops/codepipeline"
  for_each           = var.codepipeline_enabled ? { this = true } : {}
  repository_name    = module.codecommit["this"].repository_name
  build_project_name = module.codebuild["this"].project_name
}

################################
# GLUE MODULE
################################
module "glue" {
  source   = "./modules/glue"
  for_each = var.glue_enabled ? var.glue_jobs : {}

  s3_bucket  = "${local.name}-s3-${each.key}-${random_string.suffix.result}"
  iam_role   = "${local.name}-gluerole-${each.key}-${random_string.suffix.result}"
  iam_policy = "${local.name}-gluepolicy-${each.key}-${random_string.suffix.result}"
  catalog    = "${local.name}-catalog-${each.key}-${random_string.suffix.result}"
  crawler    = "${local.name}-crawler-${each.key}-${random_string.suffix.result}"
  job        = "${local.name}-job-${each.key}-${random_string.suffix.result}"
}

################################
# OPENSEARCH MODULE
################################
module "opensearch" {
  source   = "./modules/opensearch"
  for_each = var.opensearch_enabled ? var.opensearch_domains : {}

  instance_type = each.value.instance_type
  region        = var.aws_region
}

################################
# SAGEMAKER MODULE
################################
module "sagemaker" {
  source   = "./modules/sagemaker"
  for_each = var.sagemaker_enabled ? var.sagemaker_notebooks : {}

  notebook_instance_type = each.value.notebook_instance_type
}

################################
# QUICKSIGHT MODULE
################################
module "quicksight" {
  source   = "./modules/quicksight"
  for_each = var.quicksight_enabled ? { this = true } : {}
}

################################
# ECS MODULE
################################
module "ecs" {
  source   = "./modules/ecs"
  for_each = var.ecs_enabled ? var.ecs_clusters : {}

  ecs_name            = "${local.name}-ecs-${each.key}-${random_string.suffix.result}"
  container_insights  = each.value.container_insights
  enable_fargate_spot = each.value.enable_fargate_spot
}

################################
# SQS MODULE
################################
module "sqs" {
  source   = "./modules/sqs"
  for_each = var.sqs_enabled ? var.sqs_queues : {}

  queue_name                 = each.key
  delay_seconds              = each.value.delay_seconds
  max_message_size           = each.value.max_message_size
  message_retention_seconds  = each.value.message_retention_seconds
  visibility_timeout_seconds = each.value.visibility_timeout_seconds
}

################################
# API GATEWAY MODULE
################################
module "apigw" {
  source   = "./modules/apigw"
  for_each = var.apigw_enabled ? var.apigw_apis : {}

  name = "${local.name}-apigw-${each.key}-${random_string.suffix.result}"
}

################################
# BEDROCK AGENT
################################
module "bedrock_agent" {
  source   = "./modules/bedrock/agent"
  for_each = var.bedrock_agent_enabled ? var.bedrock_agents : {}

  agent_name = "${local.name}-br-${each.key}-${random_string.suffix.result}"
}

################################
# BEDROCK KNOWLEDGE BASE
################################
module "bedrock_kb" {
  source   = "./modules/bedrock/knowledgebase"
  for_each = var.bedrock_kb_enabled ? var.bedrock_kbs : {}

  kb_name = "${local.name}-kb-${each.key}-${random_string.suffix.result}"
}

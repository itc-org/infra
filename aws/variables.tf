########################################
# Global
########################################
variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

########################################
# VPC  (single shared network per account)
# Enable this whenever you turn on ec2 / eks / ecs / rds / redshift.
########################################
variable "vpc_enabled" {
  type    = bool
  default = false
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

########################################
# EC2   (add a map key to create another instance)
########################################
variable "ec2_enabled" {
  type    = bool
  default = false
}

variable "ec2_instances" {
  description = "Map of EC2 instances. Add a key to deploy another."
  type = map(object({
    ami            = string
    instance_type  = string
    key_name       = string
    instance_count = optional(number, 1)
  }))
  default = {}
}

########################################
# EKS
########################################
variable "eks_enabled" {
  type    = bool
  default = false
}

variable "eks_clusters" {
  description = "Map of EKS clusters (cluster name = map key)."
  type        = map(object({}))
  default     = {}
}

########################################
# S3
########################################
variable "s3_enabled" {
  type    = bool
  default = false
}

variable "s3_buckets" {
  description = "Map of S3 buckets. Add a key to create another."
  type = map(object({
    bucket_prefix = string
  }))
  default = {}
}

########################################
# RDS
########################################
variable "rds_enabled" {
  type    = bool
  default = false
}

variable "rds_instances" {
  description = "Map of RDS instances. Add a key to create another."
  type = map(object({
    engine      = string
    db_username = string
    db_password = string
  }))
  default = {}
}

########################################
# Redshift
########################################
variable "redshift_enabled" {
  type    = bool
  default = false
}

variable "redshift_clusters" {
  description = "Map of Redshift clusters. Add a key to create another."
  type = map(object({
    master_username = string
    master_password = string
    node_type       = optional(string, "dc2.large")
    cluster_type    = optional(string, "single-node")
    number_of_nodes = optional(number, 1)
  }))
  default = {}
}

########################################
# Lambda
########################################
variable "lambda_enabled" {
  type    = bool
  default = false
}

variable "lambda_functions" {
  description = "Map of Lambda functions. Add a key to create another."
  type = map(object({
    role_arn = string
    runtime  = string
    handler  = string
  }))
  default = {}
}

########################################
# ECR
########################################
variable "ecr_enabled" {
  type    = bool
  default = false
}

variable "ecr_repos" {
  description = "Map of ECR repositories (repo name = map key)."
  type        = map(object({}))
  default     = {}
}

########################################
# SNS
########################################
variable "sns_enabled" {
  type    = bool
  default = false
}

variable "sns_topics" {
  description = "Map of SNS topics (name = map key)."
  type        = map(object({}))
  default     = {}
}

########################################
# Glue
########################################
variable "glue_enabled" {
  type    = bool
  default = false
}

variable "glue_jobs" {
  description = "Map of Glue stacks (name = map key)."
  type        = map(object({}))
  default     = {}
}

########################################
# OpenSearch
########################################
variable "opensearch_enabled" {
  type    = bool
  default = false
}

variable "opensearch_domains" {
  description = "Map of OpenSearch domains. Add a key to create another."
  type = map(object({
    instance_type = string
  }))
  default = {}
}

########################################
# SageMaker
########################################
variable "sagemaker_enabled" {
  type    = bool
  default = false
}

variable "sagemaker_notebooks" {
  description = "Map of SageMaker notebooks. Add a key to create another."
  type = map(object({
    notebook_instance_type = string
  }))
  default = {}
}

########################################
# QuickSight  (account-level, single)
########################################
variable "quicksight_enabled" {
  type    = bool
  default = false
}

########################################
# ECS
########################################
variable "ecs_enabled" {
  type    = bool
  default = false
}

variable "ecs_clusters" {
  description = "Map of ECS clusters (name = map key)."
  type        = map(object({}))
  default     = {}
}

########################################
# SQS
########################################
variable "sqs_enabled" {
  type    = bool
  default = false
}

variable "sqs_queues" {
  description = "Map of SQS queues (queue name = map key)."
  type = map(object({
    delay_seconds              = optional(number, 0)
    max_message_size           = optional(number, 262144)
    message_retention_seconds  = optional(number, 345600)
    visibility_timeout_seconds = optional(number, 30)
  }))
  default = {}
}

########################################
# API Gateway
########################################
variable "apigw_enabled" {
  type    = bool
  default = false
}

variable "apigw_apis" {
  description = "Map of API Gateway APIs (name = map key)."
  type        = map(object({}))
  default     = {}
}

########################################
# DevOps  (CodeCommit -> CodeBuild -> CodePipeline, single chain)
########################################
variable "codecommit_enabled" {
  type    = bool
  default = false
}

variable "codebuild_enabled" {
  type    = bool
  default = false
}

variable "codepipeline_enabled" {
  type    = bool
  default = false
}

########################################
# Bedrock
########################################
variable "bedrock_agent_enabled" {
  type    = bool
  default = false
}

variable "bedrock_agents" {
  description = "Map of Bedrock agents (name = map key)."
  type        = map(object({}))
  default     = {}
}

variable "bedrock_kb_enabled" {
  type    = bool
  default = false
}

variable "bedrock_kbs" {
  description = "Map of Bedrock knowledge bases (name = map key)."
  type        = map(object({}))
  default     = {}
}

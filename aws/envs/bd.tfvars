########################################
# Environment: BD Training
# AWS Account: 743737183475  (profile: bdtraining)
# Workspace:   bd   -> resources named tf-bd-<svc>-<key>-<suffix>
#
# Usage:
#   cd aws
#   terraform workspace new bd        # first time only
#   terraform workspace select bd
#   terraform plan  -var-file=envs/bd.tfvars
#   terraform apply -var-file=envs/bd.tfvars
#
# To deploy a service: set its *_enabled = true (enable vpc_enabled too for
# ec2/eks/ecs/rds/redshift). To create more than one, add another map key.
########################################

aws_region = "eu-west-2"

########################################
# Enable / disable toggles
########################################
vpc_enabled           = false # enable for ec2 / eks / ecs / rds / redshift
ec2_enabled           = false
eks_enabled           = false
s3_enabled            = false
rds_enabled           = false
redshift_enabled      = false
lambda_enabled        = false
ecr_enabled           = false
sns_enabled           = false
glue_enabled          = false
opensearch_enabled    = false
sagemaker_enabled     = false
quicksight_enabled    = false
ecs_enabled           = false
sqs_enabled           = false
apigw_enabled         = false
codecommit_enabled    = false
codebuild_enabled     = false
codepipeline_enabled  = false
bedrock_agent_enabled = false
bedrock_kb_enabled    = false

########################################
# VPC (single shared network)
########################################
vpc_cidr_block = "10.0.0.0/16"

########################################
# EC2  (add a key for another instance)
########################################
ec2_instances = {
  ec2_1 = {
    ami            = "ami-00bab898728648dab"
    instance_type  = "t2.micro" # keep within the training instance-type guardrail
    key_name       = "terraform-keypair"
    instance_count = 1
  }
  # ec2_2 = {
  #   ami           = "ami-00bab898728648dab"
  #   instance_type = "t2.micro"
  #   key_name      = "terraform-keypair"
  # }
}

########################################
# EKS  (add a key for another cluster)
########################################
eks_clusters = {
  # eks_1 = {}
}

########################################
# S3  (add a key for another bucket)
########################################
s3_buckets = {
  s3_1 = { bucket_prefix = "itc-bd-training" }
}

########################################
# RDS  (replace passwords / move to secrets)
########################################
rds_instances = {
  # rds_1 = { engine = "mysql", db_username = "admin", db_password = "Terraform123!" }
}

########################################
# Redshift
########################################
redshift_clusters = {
  # rs_1 = { master_username = "admin", master_password = "Terraform123!", node_type = "dc2.large", number_of_nodes = 1 }
}

########################################
# Lambda
########################################
lambda_functions = {
  # fn_1 = { role_arn = "arn:aws:iam::743737183475:role/lambda-role", runtime = "python3.11", handler = "lambda_function.lambda_handler" }
}

########################################
# ECR
########################################
ecr_repos = {
  # repo_1 = {}
}

########################################
# SNS
########################################
sns_topics = {
  # topic_1 = {}
}

########################################
# Glue
########################################
glue_jobs = {
  # glue_1 = {}
}

########################################
# OpenSearch
########################################
opensearch_domains = {
  # os_1 = { instance_type = "t3.small.search" }
}

########################################
# SageMaker
########################################
sagemaker_notebooks = {
  # nb_1 = { notebook_instance_type = "ml.t3.medium" }
}

########################################
# ECS
########################################
ecs_clusters = {
  # ecs_1 = {}
}

########################################
# SQS  (queue name = map key)
########################################
sqs_queues = {
  # orders = { delay_seconds = 0, max_message_size = 262144, message_retention_seconds = 345600, visibility_timeout_seconds = 30 }
}

########################################
# API Gateway
########################################
apigw_apis = {
  # api_1 = {}
}

########################################
# Bedrock
########################################
bedrock_agents = {
  # agent_1 = {}
}

bedrock_kbs = {
  # kb_1 = {}
}

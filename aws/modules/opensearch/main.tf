resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

data "aws_caller_identity" "current" {}

resource "aws_opensearch_domain" "this" {
  domain_name    = "terraform-opensearch-${random_string.suffix.result}"
  engine_version = "OpenSearch_2.11"

  cluster_config {
    instance_type  = var.instance_type
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
      Action = "es:*"
      Resource = "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/terraform-opensearch-${random_string.suffix.result}/*"
    }]
  })
}
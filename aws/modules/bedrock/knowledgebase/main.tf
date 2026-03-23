resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

################################
# IAM Role
################################

resource "aws_iam_role" "bedrock_kb_role" {
  name = "terraform-${terraform.workspace}-bedrock-kb-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "bedrock.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

################################
# OpenSearch Serverless Collection
################################

resource "aws_opensearchserverless_collection" "vector" {
  name = "terraform-${terraform.workspace}-${random_string.suffix.result}"
  type = "VECTORSEARCH"
}

################################
# Bedrock Knowledge Base
################################

resource "aws_bedrockagent_knowledge_base" "this" {
  name     = var.kb_name
  role_arn = aws_iam_role.bedrock_kb_role.arn

  knowledge_base_configuration {
    type = "VECTOR"

    vector_knowledge_base_configuration {
      embedding_model_arn = "arn:aws:bedrock:eu-west-2::foundation-model/amazon.titan-embed-text-v1"
    }
  }

  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"

    opensearch_serverless_configuration {
      collection_arn    = aws_opensearchserverless_collection.vector.arn
      vector_index_name = "bedrock-index"

      field_mapping {
        vector_field   = "vector"
        text_field     = "text"
        metadata_field = "metadata"
      }
    }
  }
}
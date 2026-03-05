resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_iam_role" "bedrock_agent_role" {
  name = "terraform-${terraform.workspace}-bedrock-agent-${random_string.suffix.result}"

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

resource "aws_bedrockagent_agent" "this" {
  agent_name = "terraform-${terraform.workspace}-${random_string.suffix.result}"

  foundation_model        = "anthropic.claude-3-sonnet-20240229-v1:0"
  agent_resource_role_arn = aws_iam_role.bedrock_agent_role.arn

  instruction = "You are a helpful assistant created by Terraform. Answer user questions clearly and accurately."
}
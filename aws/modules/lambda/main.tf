resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

data "archive_file" "lambda" {
  type = "zip"

  source {
    content  = <<EOF
def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": "placeholder lambda"
    }
EOF
    filename = "lambda_function.py"
  }

  output_path = "${path.module}/lambda.zip"
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# CloudWatch Logs
resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# S3
resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Secrets Manager
resource "aws_iam_role_policy_attachment" "secrets" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# DynamoDB
resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_lambda_function" "this" {
  function_name = "terraform-lambda-${random_string.suffix.result}"

  role    = aws_iam_role.lambda_role.arn
  runtime = var.runtime
  handler = var.handler

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
}
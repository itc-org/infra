resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_iam_role" "sagemaker_execution" {
  name = "tf-${terraform.workspace}-sm-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "sagemaker.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_sagemaker_notebook_instance" "this" {
  name          = "tf-${terraform.workspace}-notebook-${random_string.suffix.result}"
  role_arn      = aws_iam_role.sagemaker_execution.arn
  instance_type = var.notebook_instance_type

  lifecycle_config_name = null
  platform_identifier   = "notebook-al2-v1"

  tags = {
    Name = "terraform-sagemaker-notebook"
  }
}

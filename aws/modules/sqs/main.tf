resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_sqs_queue" "this" {
  name = "tf-${terraform.workspace}-sqs-${random_string.suffix.result}"

  delay_seconds               = var.delay_seconds  
  max_message_size            = var.max_message_size
  message_retention_seconds   = var.message_retention_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
}
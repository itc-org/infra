resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_quicksight_account_subscription" "this" {
  edition               = "STANDARD"
  authentication_method = "IAM_AND_QUICKSIGHT"
  account_name          = "tf-${terraform.workspace}-qs-${random_string.suffix.result}"
  notification_email    = "admin@example.com"
}

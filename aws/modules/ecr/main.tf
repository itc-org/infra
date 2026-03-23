
resource "aws_ecr_repository" "this" {
  name = var.ecr_name

  force_delete = true
}
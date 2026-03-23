resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "this" {
  bucket = "tf-${terraform.workspace}-s3-${random_string.suffix.result}"

  tags = {
    Name = "tf-${terraform.workspace}-s3-${random_string.suffix.result}"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

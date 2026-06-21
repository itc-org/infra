terraform {
  # Partial backend: bucket/key supplied per-account at init via
  #   terraform init -backend-config="envs/<workspace>.s3.tfbackend"
  backend "s3" {
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true # S3 native locking (no DynamoDB)
  }
}




provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      tech      = terraform.workspace
    }
  }
}
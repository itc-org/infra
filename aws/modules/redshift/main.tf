########################################
# Random Suffix
########################################

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

########################################
# Security Group (Public Access on 5439)
########################################

resource "aws_security_group" "redshift_sg" {
  name        = "tf-${terraform.workspace}-rs-sg-${random_string.suffix.result}"
  description = "Redshift security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow Redshift access"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks # e.g. ["0.0.0.0/0"] for full public
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# Subnet Group
########################################

resource "aws_redshift_subnet_group" "this" {
  name       = "tf-${terraform.workspace}-rs-subnet-${random_string.suffix.result}"
  subnet_ids = var.subnet_ids
}

########################################
# IAM Role for S3 Access
########################################

resource "aws_iam_role" "redshift_role" {
  name = "tf-${terraform.workspace}-rs-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "redshift.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_s3_attach" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

########################################
# Redshift Cluster (Dev/Test Mode)
########################################

resource "aws_redshift_cluster" "this" {
  cluster_identifier = "tf-${terraform.workspace}-rs-${random_string.suffix.result}"
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password

  # Dev/Test Settings
  cluster_type = "single-node"
  node_type    = "dc2.large"

  iam_roles                 = [aws_iam_role.redshift_role.arn]
  cluster_subnet_group_name = aws_redshift_subnet_group.this.name
  vpc_security_group_ids    = [aws_security_group.redshift_sg.id]

  publicly_accessible = true
  skip_final_snapshot = true
  encrypted           = true
}
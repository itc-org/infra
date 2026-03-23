
########################################
# Single S3 Bucket
########################################

resource "aws_s3_bucket" "data_bucket" {
  bucket = var.s3_bucket
}

########################################
# IAM Role for Glue
########################################

resource "aws_iam_role" "glue_role" {
  name = var.iam_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "glue.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach AWS Managed Glue Policy
resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

########################################
# S3 Access Policy 
########################################

resource "aws_iam_policy" "glue_s3_policy" {
  name = var.iam_policy

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ]
      Resource = [
        aws_s3_bucket.data_bucket.arn,
        "${aws_s3_bucket.data_bucket.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_s3_attach" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_s3_policy.arn
}

########################################
# Glue Catalog Database
########################################

resource "aws_glue_catalog_database" "this" {
  name = var.catalog
}

########################################
# Glue Crawler
########################################

resource "aws_glue_crawler" "this" {
  name          = var.crawler
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.this.name

  s3_target {
    path = "s3://${aws_s3_bucket.data_bucket.bucket}/raw/"
  }
}

########################################
# Glue Job
########################################

resource "aws_glue_job" "this" {
  name     = var.job
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.data_bucket.bucket}/scripts/job.py"
    python_version  = "3"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"

  default_arguments = {
    "--job-language" = "python"
  }
}
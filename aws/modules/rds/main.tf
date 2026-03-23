resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

################################
# Security Group
################################

resource "aws_security_group" "this" {
  name   = "tf-${terraform.workspace}-rds-sg-${random_string.suffix.result}"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

################################
# Subnet Group
################################

resource "aws_db_subnet_group" "this" {
  name       = "tf-${terraform.workspace}-rds-subnet-${random_string.suffix.result}"
  subnet_ids = var.private_subnet_ids
}

################################
# RDS Instance (micro)
################################

resource "aws_db_instance" "this" {
  identifier             = "tf-${terraform.workspace}-rds-${random_string.suffix.result}"
  engine                 = var.rds_engine
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  skip_final_snapshot    = true
  publicly_accessible    = true
  deletion_protection    = false
}

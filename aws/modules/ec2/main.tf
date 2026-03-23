# ################################
# # Random suffix
# ################################

# resource "random_string" "suffix" {
#   length  = 5
#   special = false
#   upper   = false
# }

################################
# Security Group
################################

data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

resource "aws_security_group" "this" {
  name   = var.sg_name
  vpc_id = data.aws_subnet.selected.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

################################
# EC2 Instance
################################

resource "aws_instance" "this" {
  count         = var.instance_count
  ami           = var.ami
  instance_type = var.instance_type


  subnet_id            = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name = var.key_name 

  tags = {
    Name = var.ec2_name
  }
}

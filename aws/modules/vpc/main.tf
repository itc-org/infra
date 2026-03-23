
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

data "aws_availability_zones" "available" {}

#################################
# VPC
#################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-${terraform.workspace}-vpc-${random_string.suffix.result}"
  }
}

#################################
# Internet Gateway
#################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "tf-${terraform.workspace}-igw-${random_string.suffix.result}"
  }
}

#################################
# Public Subnets (3)
#################################

resource "aws_subnet" "public" {
  count = 3

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "tf-${terraform.workspace}-pub-${count.index}-${random_string.suffix.result}"
  }
}

#################################
# Private Subnets (3)
#################################

resource "aws_subnet" "private" {
  count = 3

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 4, count.index + 3)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "tf-${terraform.workspace}-prv-${count.index}-${random_string.suffix.result}"
  }
}

#################################
# Public Route Table
#################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id    
  }

  tags = {
    Name = "tf-${terraform.workspace}-pub-rt-${random_string.suffix.result}"
  }
}

resource "aws_route_table_association" "public" {
  count = 3

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#################################
# NAT Gateway (Single - Simple Setup)
#################################

# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public[0].id

#   tags = {
#     Name = "terraform-nat-${random_string.suffix.result}"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }

#################################
# Private Route Table
#################################

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "terraform-private-rt-${random_string.suffix.result}"
#   }
# }

# resource "aws_route_table_association" "private" {
#   count = 3

#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }
variable "name" {}
variable "vpc_id" {}
variable "subnet_ids" {}

variable "instance_type" {
  type    = string
  default = "t3.medium" # moderate, cost-conscious (burstable)
}

variable "desired_size" {
  type    = number
  default = 1 # start with 1 node; bump to 2 later
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2 # headroom so desired can be raised to 2 without changing max
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.name
  cluster_version = "1.30"

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true # public API endpoint

  eks_managed_node_groups = {
    default = {
      name           = var.name
      instance_types = [var.instance_type]

      desired_size = var.desired_size
      min_size     = var.min_size
      max_size     = var.max_size

      ami_type                    = "AL2023_x86_64_STANDARD"
      associate_public_ip_address = true # nodes in public subnets
    }
  }
}

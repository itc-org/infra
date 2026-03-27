variable "name" {}
variable "vpc_id" {}
variable "subnet_ids" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.name
  cluster_version = "1.30"

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  eks_managed_node_groups = {
    default = {
      name           = var.name
      instance_types = ["t3.medium"]

      desired_size = 1
      min_size     = 1
      max_size     = 1

      ami_type                      = "AL2023_x86_64_STANDARD"
      associate_public_ip_address   = true
    }
  }
}
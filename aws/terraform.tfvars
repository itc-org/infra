# Per-account configuration lives in envs/<workspace>.tfvars
# (bd.tfvars, ds.tfvars, java.tfvars). This root file is intentionally left
# almost empty so a plain run deploys nothing.
#
#   terraform workspace select bd
#   terraform apply -var-file=envs/bd.tfvars
#
# All service toggles default to false, so nothing is created unless an
# env file enables it.

aws_region = "eu-west-2"

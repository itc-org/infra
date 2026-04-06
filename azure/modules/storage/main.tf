resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

########################################
# STORAGE ACCOUNT 
########################################
resource "azurerm_storage_account" "st" {
  for_each = var.storage

  name = lower("tf${terraform.workspace}${each.key}${local.suffix}")  # no hyphens

  resource_group_name      = var.resource_group_name
  location                 = var.location

  account_tier             = "Standard"   # ✅ low cost
  account_replication_type = "LRS"        # ✅ cheapest

  # keep minimal features (cost saving)
  access_tier = "Hot"

  tags = var.tags
}
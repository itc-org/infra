resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

########################################
# STORAGE ACCOUNT (ADLS GEN2)
########################################
resource "azurerm_storage_account" "st" {
  for_each = var.datalake

  name = "tf${terraform.workspace}${each.key}${local.suffix}"  

  location            = var.location
  resource_group_name = var.resource_group_name

  account_tier             = "Standard"
  account_replication_type = "LRS"

  is_hns_enabled = true   # ✅ Data Lake Gen2
   tags = var.tags
}

########################################
# FILE SYSTEM (CONTAINER)
########################################
resource "azurerm_storage_data_lake_gen2_filesystem" "fs" {
  for_each = var.datalake

  name               = "synapse"   
  storage_account_id = azurerm_storage_account.st[each.key].id
}
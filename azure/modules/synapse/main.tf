resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

resource "azurerm_synapse_workspace" "syn" {
  for_each = var.synapse  

  name = "tf-${terraform.workspace}-${each.key}-syn-${local.suffix}"

  location            = var.location
  resource_group_name = var.resource_group_name

  sql_administrator_login          = var.sql_admin_username
  sql_administrator_login_password = var.sql_admin_password


  storage_data_lake_gen2_filesystem_id = values(var.filesystem_ids)[0]

  identity {
    type = "SystemAssigned"
  }
}
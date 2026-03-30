#enable datalake (storage account) and file system if datalake doesnt exist already

# ############################################
# # Storage Account 
# ############################################
# resource "azurerm_storage_account" "syn_storage" {
#   name                     = lower(replace(var.name, "-", "")) # must be 3-24 lowercase
#   resource_group_name      = var.resource_group_name
#   location                 = var.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   is_hns_enabled           = true

#   tags = var.tags
# }

# ############################################
# # Data Lake Gen2 Filesystem
# ############################################
# resource "azurerm_storage_data_lake_gen2_filesystem" "syn_fs" {
#   name               = "synfs"
#   storage_account_id = azurerm_storage_account.syn_storage.id
# }

############################################
# Synapse Workspace
############################################
resource "azurerm_synapse_workspace" "syn" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location


  storage_data_lake_gen2_filesystem_id = var.filesystem_id
  managed_virtual_network_enabled = false

  sql_administrator_login          = var.sql_admin_login
  sql_administrator_login_password = var.sql_admin_password

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
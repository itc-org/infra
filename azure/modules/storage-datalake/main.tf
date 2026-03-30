resource "azurerm_storage_account" "datalake" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.datalake_tier
  account_replication_type = var.datlake_redundancy

  is_hns_enabled = true  

  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false

  tags = var.tags
}


resource "azurerm_storage_data_lake_gen2_filesystem" "fs" {
  name               = var.filesystem_name
  storage_account_id = azurerm_storage_account.datalake.id
}
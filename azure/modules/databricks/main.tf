resource "azurerm_databricks_workspace" "dbx" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  managed_resource_group_name  = var.managed_resource_group_name
  public_network_access_enabled = var.databricks_public_network_access_enabled  

  tags = var.tags
}
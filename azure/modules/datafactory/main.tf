resource "azurerm_data_factory" "adf" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
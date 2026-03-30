resource "azurerm_key_vault" "kv" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  enable_rbac_authorization = true

  purge_protection_enabled = false  

  tags = var.tags

  lifecycle {
    ignore_changes = [
      access_policy
    ]
  }
}
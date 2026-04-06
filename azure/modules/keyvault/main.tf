resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

resource "azurerm_key_vault" "kv" {
  name = "tf-${terraform.workspace}-kv-${local.suffix}"

  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  sku_name = var.keyvault.sku_name

  enabled_for_disk_encryption = var.keyvault.enabled_for_disk_encryption

  enable_rbac_authorization = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
}
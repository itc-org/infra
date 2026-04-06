resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

resource "azurerm_databricks_workspace" "dbx" {
  for_each = var.databricks

  name = "tf-${terraform.workspace}-${each.key}-dbx-${local.suffix}"

  location            = var.location
  resource_group_name = var.resource_group_name

  sku = each.value.sku
  tags = var.tags
}
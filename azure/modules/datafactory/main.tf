resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

resource "azurerm_data_factory" "adf" {
  for_each = var.datafactory

  name = "tf-${terraform.workspace}-${each.key}-adf-${local.suffix}"

  location            = var.location
  resource_group_name = var.resource_group_name
}
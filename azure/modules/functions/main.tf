resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

############################################
# STORAGE ACCOUNT (REQUIRED)
############################################
resource "azurerm_storage_account" "func_storage" {
  for_each = var.functions

  name = lower(replace("tf${terraform.workspace}${each.key}${local.suffix}", "-", ""))

  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

############################################
# APP SERVICE PLAN (CONSUMPTION)
############################################
resource "azurerm_service_plan" "func_plan" {
  for_each = var.functions

  name                = "tf-${terraform.workspace}-${each.key}-plan-${local.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type  = "Linux"
  sku_name = "Y1"

  tags = var.tags
}

############################################
# FUNCTION APP
############################################
resource "azurerm_linux_function_app" "func" {
  for_each = var.functions

  name = "tf-${terraform.workspace}-${each.key}-func-${local.suffix}"

  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id            = azurerm_service_plan.func_plan[each.key].id
  storage_account_name       = azurerm_storage_account.func_storage[each.key].name
  storage_account_access_key = azurerm_storage_account.func_storage[each.key].primary_access_key

  site_config {}

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
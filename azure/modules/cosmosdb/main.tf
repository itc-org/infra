resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

########################################
# COSMOS ACCOUNT
########################################
resource "azurerm_cosmosdb_account" "db" {
  for_each = var.cosmos

  name = lower("tf-${terraform.workspace}-${each.key}-${local.suffix}")

  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = var.tags
}

########################################
# SQL DATABASE
########################################
resource "azurerm_cosmosdb_sql_database" "sql_db" {
  for_each = var.cosmos

  name                = "${lower(each.key)}-sqldb"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.db[each.key].name
}
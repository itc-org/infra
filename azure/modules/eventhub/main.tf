resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

############################################
# EVENT HUB NAMESPACE
############################################
resource "azurerm_eventhub_namespace" "ns" {
  for_each = var.eventhub

  name = lower("tf-${terraform.workspace}-${each.key}-eh-${local.suffix}")

  location            = var.location
  resource_group_name = var.resource_group_name

  sku      = "Standard"
  capacity = 1

  tags = var.tags
}

############################################
# EVENT HUB
############################################
resource "azurerm_eventhub" "hub" {
  for_each = var.eventhub

  name = "${each.key}-hub"

  namespace_name      = azurerm_eventhub_namespace.ns[each.key].name
  resource_group_name = var.resource_group_name

  partition_count   = 2
  message_retention = 1
}
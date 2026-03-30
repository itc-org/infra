########################################
# 4 Character Random Suffix
########################################
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
  numeric = true
}


locals {
  suffix = random_string.suffix.result

  common_tags = {
    ManagedBy = "Terraform"
    tech      = terraform.workspace
  }

  needs_network = (
    contains(var.services_to_deploy, "vm") ||
    contains(var.services_to_deploy, "aks")
    # contains(var.services_to_deploy, "bastion") ||
    # contains(var.services_to_deploy, "private_endpoint")
  )
}

########################################
# Resource Group
########################################
resource "azurerm_resource_group" "rg" {
  name     = "tf-${terraform.workspace}-rg-${local.suffix}"
  location = "northeurope"
  tags     = local.common_tags
}

########################################
# Modules 
########################################

#change data to "tf-${terraform.workspace}-rg-${local.suffix}" or rm because its already being created on line 31
#when applying new use azurerm_resource_group.rg.name
data "azurerm_resource_group" "rg" {
  name = "Itc_Bigdata"
}

module "databricks" {
  source   = "./modules/databricks"
  for_each = contains(var.services_to_deploy, "databricks") ? { databricks = true } : {}

  name                                     = var.databricks_name
  resource_group_name                      = data.azurerm_resource_group.rg.name
  location                                 = azurerm_resource_group.rg.location
  managed_resource_group_name              = var.managed_resource_group_name
  databricks_public_network_access_enabled = var.databricks_public_network_access_enabled
  sku                                      = var.databricks_sku
  tags                                     = local.common_tags

}

module "datafactory" {
  source   = "./modules/datafactory"
  for_each = contains(var.services_to_deploy, "datafactory") ? { datafactory = true } : {}

  name                = var.datafactory_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.common_tags
}

module "keyvault" {
  source   = "./modules/keyvault"
  for_each = contains(var.services_to_deploy, "keyvault") ? { keyvault = true } : {}

  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tenant_id           = var.tenant_id
  sku_name            = var.key_vault_sku_name

  tags = local.common_tags
}

module "storage-datalake" {
  source   = "./modules/storage-datalake"
  for_each = contains(var.services_to_deploy, "storage-datalake") ? { storage-datalake = true } : {}

  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  datalake_tier       = var.datalake_tier
  datlake_redundancy  = var.datlake_redundancy
  filesystem_name     = var.filesystem_name

  tags = local.common_tags
}



module "synapse" {
  source   = "./modules/synapse"
  for_each = contains(var.services_to_deploy, "synapse") ? { synapse = true } : {}

  name                = var.synapse_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sql_admin_login     = var.sql_admin_login
  sql_admin_password  = var.sql_admin_password
  filesystem_id = module.storage-datalake["storage-datalake"].filesystem_id
  tags                = local.common_tags
}

module "functions" {
  source   = "./modules/functions"
  for_each = contains(var.services_to_deploy, "functions") ? { functions = true } : {}

  name                = "terraform-functions-${local.suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.common_tags
}

module "cosmosdb" {
  source   = "./modules/cosmosdb"
  for_each = contains(var.services_to_deploy, "cosmosdb") ? { cosmosdb = true } : {}

  name                = "terraform-cosmos-${local.suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.common_tags
}

module "eventhub" {
  source   = "./modules/eventhub"
  for_each = contains(var.services_to_deploy, "eventhub") ? { eventhub = true } : {}

  name                = "terraform-eventhub-${local.suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.common_tags
}


########################################
# Network (Shared)
########################################
module "network" {
  source   = "./modules/network"
  for_each = local.needs_network ? { network = true } : {}

  vnet_name           = "terraform-vnet-${local.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vnet_address_space  = var.vnet_address_space
  tags                = local.common_tags
}

########################################
# VM
########################################
module "vm" {
  source   = "./modules/vm"
  for_each = contains(var.services_to_deploy, "vm") ? { vm = true } : {}

  name                = "terraform-vm-${local.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = module.network["network"].vnet_name
  subnet_prefix       = var.vm_subnet_prefix

  vm_size        = var.vm_size
  admin_username = var.vm_admin_username
  admin_password = var.vm_admin_password

  tags = local.common_tags
}


########################################
# AKS
########################################
module "aks" {
  source   = "./modules/aks"
  for_each = contains(var.services_to_deploy, "aks") ? { aks = true } : {}

  name                = "terraform-aks-${local.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = module.network["network"].vnet_name
  subnet_prefix       = var.aks_subnet_prefix

  vm_size    = var.aks_vm_size
  node_count = var.aks_node_count

  tags = local.common_tags
}
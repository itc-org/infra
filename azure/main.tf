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
}

data "azurerm_client_config" "current" {}

########################################
# Resource Group
########################################
resource "azurerm_resource_group" "rg" {
  name     = "tf-${terraform.workspace}-rg-${local.suffix}"
  location = "northeurope"
}

########################################
# NETWORK 
########################################
module "network" {
  source = "./modules/network"

  count = var.network_enabled ? 1 : 0

  vnet_name           = "tf-${terraform.workspace}-vnet-${local.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  vnet_address_space = var.vnet_address_space
  subnets            = var.subnets

  tags = local.common_tags
}

########################################
# VM windows
########################################
module "vm" {
  source = "./modules/vm"

  count = var.vm_enabled ? 1 : 0

  vm_enabled = var.vm_enabled
  vms        = var.vms

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  subnet_ids = module.network[0].subnet_ids # assumes network enabled

  admin_username = var.vm_admin_username
  admin_password = var.vm_admin_password

  tags = local.common_tags
}

########################################
# VM Linux
########################################

module "vm_linux" {
  source = "./modules/vm-linux"

  count = var.vm_linux_enabled && length(var.linux_vms) > 0 ? 1 : 0

  vms = var.linux_vms
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  subnet_ids = module.network[0].subnet_ids

  admin_username = var.vm_admin_username
  admin_password = var.vm_admin_password
}

########################################
# KEY VAULT
########################################
module "keyvault" {
  source              = "./modules/keyvault"
  count               = var.keyvault_enabled ? 1 : 0
  keyvault            = var.keyvault
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

########################################
# AKS
########################################
module "aks" {
  source = "./modules/aks"

  count = var.aks_enabled ? 1 : 0
  aks   = var.aks

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  subnet_id = module.network[0].subnet_ids[var.aks.subnet_name]
}


########################################
# databricks
########################################

module "databricks" {
  source = "./modules/databricks"

  count = var.databricks_enabled ? 1 : 0

  databricks          = var.databricks
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


########################################
# datafactory
########################################
module "datafactory" {
  source = "./modules/datafactory"
  count  = var.datafactory_enabled && length(var.datafactory) > 0 ? 1 : 0

  datafactory = var.datafactory

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}



########################################
# datalake
########################################
module "datalake" {
  source = "./modules/datalake"

  count = var.datalake_enabled && length(var.datalake) > 0 ? 1 : 0

  datalake = var.datalake

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name  
}


########################################
# synapse
########################################

module "synapse" {
  source = "./modules/synapse"

  count = var.synapse_enabled && length(var.synapse) > 0 ? 1 : 0

  synapse = var.synapse

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  filesystem_ids = module.datalake[0].filesystem_ids  

  sql_admin_username = var.synapse_sql_admin_username
  sql_admin_password = var.synapse_sql_admin_password

}

########################################
# cosmos
########################################


module "cosmos" {
  source = "./modules/cosmosdb"

  count = var.cosmos_enabled && length(var.cosmos) > 0 ? 1 : 0

  cosmos = var.cosmos

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}


########################################
# eventhub
########################################
module "eventhub" {
  source = "./modules/eventhub" 

  count = var.eventhub_enabled && length(var.eventhub) > 0 ? 1 : 0

  eventhub = var.eventhub

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}

########################################
# functions
########################################

module "functions" {
  source = "./modules/functions"
  count = var.functions_enabled && length(var.functions) > 0 ? 1 : 0

  functions = var.functions

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}


########################################
# storage account
########################################

module "storage" {
  source = "./modules/storage"

  count = var.storage_enabled && length(var.storage) > 0 ? 1 : 0

  storage = var.storage

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "tf-${terraform.workspace}-aks-${local.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_prefix = "tfaks${local.suffix}"

  kubernetes_version = "1.32.7"

  sku_tier = "Free"

  default_node_pool {
    name           = "system"
    node_count     = var.aks.node_count
    vm_size        = var.aks.vm_size
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }
 
  azure_active_directory_role_based_access_control {
    managed = true

    admin_group_object_ids = [
      "65f18cda-b7c9-451b-b37c-0bb28eef3feb"
    ]
  }

  role_based_access_control_enabled = true

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
  tags = var.tags
}
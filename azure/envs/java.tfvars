network_enabled     = false
vm_enabled          = false #must enable network
vm_linux_enabled    = false #must enable network
aks_enabled         = false #must enable network
keyvault_enabled    = false
databricks_enabled  = false
datafactory_enabled = false
datalake_enabled    = false
synapse_enabled     = false #must enable datalake
cosmos_enabled      = false
eventhub_enabled    = false
functions_enabled   = false
storage_enabled     = false


vnet_address_space = [
  "10.0.0.0/16"
]

subnets = {
  vm_subnet = {
    address_prefix = ["10.0.1.0/24"]
  }

  # aks_subnet = {
  #   address_prefix = ["10.0.2.0/24"]
  # }
}

vms = {
  vm1 = {
    size        = "Standard_B2s"
    subnet_name = "vm_subnet"
  }
  # vm2 = {                                
  #   size        = "Standard_B2s"
  #   subnet_name = "vm_subnet"
  # }
}




linux_vms = {
  lin1 = {
    size        = "Standard_B2s"
    subnet_name = "vm_subnet"
  }

}

vm_admin_username = "azureuser"
vm_admin_password = "Password123!"
########################################
# AKS
########################################
aks = {
  node_count  = 1
  vm_size     = "Standard_DS2_v2"
  subnet_name = "aks_subnet"
}

########################################
# KEY VAULT
########################################
keyvault = {
  sku_name                    = "standard"
  enabled_for_disk_encryption = true
}

########################################
# databricks
########################################
databricks = {
  dbx1 = {
    sku = "standard"
  }

  # dbx2 = {
  #   sku = "standard"
  # }
}

########################################
# datafactory
########################################

datafactory = {
  adf1 = {}
  # adf2 = {}
}

########################################
# datalake
########################################
datalake = {
  dl1 = {}
  # dl2 = {}
}

########################################
# synapse
########################################
synapse = {
  syn1 = {}
}

synapse_sql_admin_username = "sqladminuser"
synapse_sql_admin_password = "WelcomeItc#2026"


########################################
# cosmosdb
########################################
cosmos = {
  cosmos1 = {}
}


########################################
# eventhub
########################################
eventhub = {
  eh1 = {}
}


########################################
# functions
########################################
functions = {
  func1 = {}
}

########################################
# storage account
########################################
storage = {
  st1 = {}
}

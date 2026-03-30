

#databricks
databricks_name                          = "itc-bd-ne-adb" #change to "tf-${terraform.workspace}-dbx-${local.suffix}"
databricks_sku                           = "premium"
databricks_public_network_access_enabled = true
managed_resource_group_name              = "mrg-Itc_Bigdata-ne-adb" #change to "tf-${terraform.workspace}-mrg-dxb-${local.suffix}"



#datafactory
datafactory_name = "itc-bd-ne-adf" #"tf-${terraform.workspace}-adf-${local.suffix}"


#keyvault
#after creating keyvault, assign Key Vault Administrator role to selected groups in IAM

key_vault_name     = "itc-bd-ne-kv" #"tf-${terraform.workspace}-kv-${local.suffix}"
tenant_id          = "2b32b1fa-7899-482e-a6de-be99c0ff5516"
key_vault_sku_name = "standard"

#Storage (datalake)
storage_account_name = "itcbdneadls" #"tf-${terraform.workspace}-adls-${local.suffix}"
filesystem_name      = "synapse"     #container=filesystem in datalake
datalake_tier        = "Standard"
datlake_redundancy   = "LRS"


#synapse
synapse_name = "itc-bd-ne-synapse"   #"tf-${terraform.workspace}-syn-${local.suffix}"
sql_admin_login    = "sqladminuser"
sql_admin_password = "WelcomeItc#2026"




vm_size           = "Standard_B2s"
vm_admin_username = "itcsme"
vm_admin_password = "Terraform123!"

vnet_address_space = ["10.0.0.0/16"]
vm_subnet_prefix   = ["10.0.1.0/24"]
aks_subnet_prefix  = ["10.0.2.0/24"]

aks_vm_size    = "Standard_DS2_v2"
aks_node_count = 2
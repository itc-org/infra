
variable "services_to_deploy" {
  description = "List of services to deploy"
  type        = list(string)
  default     = []
}


#databricks
variable "databricks_sku" {
  description = "Databricks SKU (standard or premium)"
  type        = string
  default     = "standard"
}

variable "managed_resource_group_name" {}
variable "databricks_name" {}
variable "databricks_public_network_access_enabled" {}

#datafactory
variable "datafactory_name" {}


#Keyvault

variable "key_vault_name" {}
variable "tenant_id" {}
variable "key_vault_sku_name" {}





#Storage Account (datalake)
variable "storage_account_name" {}
variable "filesystem_name" {}
variable "datalake_tier" {}
variable "datlake_redundancy" {}



variable "sql_admin_login" {}

variable "sql_admin_password" {
  sensitive   = true
}
 variable "synapse_name" {}

#VM
variable "vm_size" {
  type = string
}

variable "vm_admin_username" {
  type = string
}

variable "vm_admin_password" {
  type      = string
  sensitive = true
}

variable "vnet_address_space" {
  type = list(string)
}

variable "vm_enabled" {
  type = bool
}

variable "vms" {
  type = map(object({
    size = string
  }))
}



variable "vm_subnet_prefix" {

}

variable "aks_subnet_prefix" {

}

variable "aks_vm_size" { type = string }
variable "aks_node_count" { type = number }
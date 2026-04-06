#RG
# variable "resource_group_enabled" {
#   type = bool
# }


#Virtual machines
variable "network_enabled" {
  type = bool
}

variable "vm_enabled" {
  type = bool
}

variable "vm_linux_enabled" { 
  type = bool 
}


variable "vnet_address_space" {
  type = list(string)
}

variable "subnets" {
  type = map(object({
    address_prefix = list(string)
  }))
}

variable "vms" {
  type = map(object({
    size        = string
    subnet_name = string
  }))
}

variable "vm_admin_username" {
  type = string
}

variable "vm_admin_password" {
  type      = string
  sensitive = true
}

#Keyvault
variable "keyvault_enabled" {
  type = bool
}

variable "keyvault" {
  type = object({
    sku_name                    = string
    enabled_for_disk_encryption = bool
  })
}


variable "linux_vms" { type = map(any) }

#AKS
variable "aks_enabled" {
  type = bool
}

variable "aks" {
  type = object({
    node_count  = number
    vm_size     = string
    subnet_name = string
  })
}

#Databricks

variable "databricks_enabled" {
  type = bool
}

variable "databricks" {
  type = map(object({
    sku = string
  }))
}

#datafactory

variable "datafactory_enabled" {
  type = bool
}

variable "datafactory" {
  type = map(any)
}

#datalake
variable "datalake_enabled" {
  type = bool
}

variable "datalake" {
  type = map(any)
}


#synapse

variable "synapse_enabled" {
  type = bool
}

variable "synapse" {
  type = map(any)
}

variable "synapse_sql_admin_username" {
  type = string
}

variable "synapse_sql_admin_password" {
  type      = string
  sensitive = true
}

#cosmos
variable "cosmos_enabled" {
  type = bool
}

variable "cosmos" {
  type = map(any)
}

#eventhub
variable "eventhub_enabled" {
  type = bool
}

variable "eventhub" {
  type = map(any)
}

#functions

variable "functions_enabled" {
  type = bool
}

variable "functions" {
  type = map(any)
}

#storage account
variable "storage_enabled" {
  type = bool
}

variable "storage" {
  type = map(any)
}
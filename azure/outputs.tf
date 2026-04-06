########################################
# NETWORK OUTPUTS
########################################
output "vnet_name" {
  value       = var.network_enabled ? module.network[0].vnet_name : null
  description = "VNet name"
}

output "subnet_ids" {
  value       = var.network_enabled ? module.network[0].subnet_ids : null
  description = "Map of subnet IDs"
}

########################################
# VM OUTPUTS
########################################
output "vm_names" {
  value = var.vm_enabled ? module.vm[0].vm_names : []
}

output "linux_vm_names" {
  value = var.vm_linux_enabled ? module.vm_linux[0].vm_names : []
}

output "vm_private_ips" {
  value = var.vm_enabled ? module.vm[0].private_ips : []
}

output "linux_vm_private_ips" {
  value = var.vm_linux_enabled ? module.vm_linux[0].private_ips : []
}


output "vm_public_ips" {
  value = var.vm_enabled ? module.vm[0].public_ips : []
}

output "linux_vm_public_ips" {  
  value = var.vm_linux_enabled ? module.vm_linux[0].public_ips : []
}

#Keyvault
output "keyvault_name" {
  value = var.keyvault_enabled ? module.keyvault[0].keyvault_name : null
}

#databricks
output "databricks_names" {
  value = var.databricks_enabled ? module.databricks[0].databricks_names : {}
}

output "databricks_urls" {
  value = var.databricks_enabled ? module.databricks[0].workspace_urls : {}
}

#datafactory
output "datafactory_names" {
  value = var.datafactory_enabled ? module.datafactory[0].datafactory_names : {}
}

#datalake

output "datalake_storage_accounts" {
  value = var.datalake_enabled ? module.datalake[0].storage_account_names : {}
}

output "datalake_filesystems" {
  value = var.datalake_enabled ? module.datalake[0].filesystem_names : {}
}


#Cosmosdb

output "cosmos_accounts" {
  value = var.cosmos_enabled ? module.cosmos[0].cosmos_account_names : {}
}

output "cosmos_databases" {
  value = var.cosmos_enabled ? module.cosmos[0].cosmos_db_names : {}
}

#eventhub

output "eventhub_namespaces" {
  value = var.eventhub_enabled ? module.eventhub[0].eventhub_namespaces : {}
}

output "eventhub_names" {
  value = var.eventhub_enabled ? module.eventhub[0].eventhub_names : {}
}

#fucntions

output "function_names" {
  value = var.functions_enabled ? module.functions[0].function_names : {}
}

#storage
output "storage_accounts" {
  value = var.storage_enabled ? module.storage[0].storage_account_names : {}
}
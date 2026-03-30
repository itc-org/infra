############################################
# Databricks
############################################
output "databricks_workspace_url" {
  value = try(module.databricks["databricks"].workspace_url, null)
}

############################################
# Data Factory
############################################
output "adf_name" {
  value = try(module.datafactory["datafactory"].data_factory_name, null)
}

############################################
# Functions
############################################
output "function_app_name" {
  value = try(module.functions["functions"].function_app_name, null)
}

output "function_app_default_hostname" {
  value = try(module.functions["functions"].default_hostname, null)
}

############################################
# Cosmos DB
############################################
output "cosmosdb_endpoint" {
  value = try(module.cosmosdb["cosmosdb"].cosmos_account_endpoint, null)
}

############################################
# EventHub
############################################
output "eventhub_namespace" {
  value = try(module.eventhub["eventhub"].eventhub_namespace_name, null)
}

############################################
# Synapse
############################################
output "synapse_workspace_id" {
  value = try(module.synapse["synapse"].workspace_id, null)
}

output "workspace_endpoint" {
  value = try(module.synapse["synapse"].workspace_endpoint, null)
}
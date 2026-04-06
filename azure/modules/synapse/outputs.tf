output "synapse_names" {
  value = {
    for k, v in azurerm_synapse_workspace.syn : k => v.name
  }
}

output "principal_ids" {
  value = {
    for k, v in azurerm_synapse_workspace.syn : k => v.identity[0].principal_id
  }
}
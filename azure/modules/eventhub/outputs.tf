output "eventhub_namespaces" {
  value = {
    for k, v in azurerm_eventhub_namespace.ns : k => v.name
  }
}

output "eventhub_names" {
  value = {
    for k, v in azurerm_eventhub.hub : k => v.name
  }
}
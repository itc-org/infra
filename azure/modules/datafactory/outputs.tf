output "datafactory_names" {
  value = {
    for k, v in azurerm_data_factory.adf : k => v.name
  }
}
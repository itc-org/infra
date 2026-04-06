output "function_names" {
  value = {
    for k, v in azurerm_linux_function_app.func : k => v.name
  }
}
output "storage_account_names" {
  value = {
    for k, v in azurerm_storage_account.st : k => v.name
  }
}

output "storage_account_ids" {
  value = {
    for k, v in azurerm_storage_account.st : k => v.id
  }
}
output "storage_account_names" {
  value = {
    for k, v in azurerm_storage_account.st : k => v.name
  }
}

output "filesystem_names" {
  value = {
    for k, v in azurerm_storage_data_lake_gen2_filesystem.fs : k => v.name
  }
}

output "filesystem_ids" {
  value = {
    for k, v in azurerm_storage_data_lake_gen2_filesystem.fs : k => v.id
  }
}
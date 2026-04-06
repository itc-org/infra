output "databricks_names" {
  value = {
    for k, v in azurerm_databricks_workspace.dbx : k => v.name
  }
}

output "workspace_urls" {
  value = {
    for k, v in azurerm_databricks_workspace.dbx : k => v.workspace_url
  }
}
output "cosmos_account_names" {
  value = {
    for k, v in azurerm_cosmosdb_account.db : k => v.name
  }
}

output "cosmos_db_names" {
  value = {
    for k, v in azurerm_cosmosdb_sql_database.sql_db : k => v.name
  }
}
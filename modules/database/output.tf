output "mysql_server_name" {
  value = azurerm_mysql_flexible_server.mysql.name
}

output "mysql_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "resource_group_name" {
  value = azurerm_resource_group.rg_database.name
}

output "storage_account_name" {
  value = azurerm_storage_account.wp_storage.name
}

output "acrname" {
  value = azurerm_container_registry.cr.name
}

output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "log_id" {
  value = azurerm_log_analytics_workspace.log.id
}

output "db_subnet_id" {
  value = azurerm_subnet.snet-db.id
}

output "mysql_dns_zone_id" {
  value = azurerm_private_dns_zone.mysql-dns.id
}
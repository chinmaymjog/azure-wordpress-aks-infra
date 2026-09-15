output "acrname" {
  value = azurerm_container_registry.cr.name
}

output "acr_login_server" {
  value = azurerm_container_registry.cr.login_server
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

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

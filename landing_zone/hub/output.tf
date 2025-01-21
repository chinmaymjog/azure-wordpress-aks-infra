output "container_registry_name" {
  value = azurerm_container_registry.cr.name
}

output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.log.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log.id
}

output "backup_policy_id" {
  value = azurerm_backup_policy_vm.bkp_policy.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "recovery_services_vault_name" {
  value = azurerm_recovery_services_vault.rsv.name
}

output "vm_subnet_id" {
  value = azurerm_subnet.snet-vm.id
}

output "db_subnet_id" {
  value = azurerm_subnet.snet-db.id
}

output "runner_subnet_id" {
  value = azurerm_subnet.snet-runner.id
}

output "vwan_id" {
  value = azurerm_virtual_hub.vwan_hub.id
}

output "tm_rgname" {
  value = azurerm_resource_group.nw.name
}

output "tm_prod_id" {
  value = azurerm_traffic_manager_profile.tm-prod.id
}

output "tm_preprod_id" {
  value = azurerm_traffic_manager_profile.tm-preprod.id
}

output "tm_dev_id" {
  value = azurerm_traffic_manager_profile.tm-dev.id
}

output "tm_lab_id" {
  value = azurerm_traffic_manager_profile.tm-lab.id
}

output "mysql_dns_zone_id" {
  value = azurerm_private_dns_zone.mysql-dns.id
}
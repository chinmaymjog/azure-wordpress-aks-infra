output "mysql_server_name" {
  value = module.database.mysql_server_name
}

output "mysql_fqdn" {
  value = module.database.mysql_fqdn
}

output "resource_group_name" {
  value = module.database.resource_group_name
}

output "storage_account_name" {
  value = module.database.storage_account_name
}

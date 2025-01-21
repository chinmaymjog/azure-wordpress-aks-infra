output "db_rg_name" {
  value = [for i, j in azurerm_resource_group.rg_database : j.name]
}
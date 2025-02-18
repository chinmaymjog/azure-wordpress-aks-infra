resource "azurerm_storage_account" "storage" {
  name                = "st${var.project}${var.env}${var.location_short}"
  resource_group_name = azurerm_resource_group.rg_database.name

  location                 = azurerm_resource_group.rg_database.location
  account_tier             = "Premium"
  account_kind             = "FileStorage"
  account_replication_type = "ZRS"
}
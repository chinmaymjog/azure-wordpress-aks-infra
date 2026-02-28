resource "azurerm_storage_account" "wp_storage" {
  name                     = substr(replace("stwp${var.project}${var.env}", "-", ""), 0, 24)
  resource_group_name      = azurerm_resource_group.rg_database.name
  location                 = azurerm_resource_group.rg_database.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
  account_kind             = var.storage_account_tier == "Premium" ? "FileStorage" : "StorageV2"

  tags = var.tags
}

resource "azurerm_key_vault_secret" "storage_account_name" {
  name         = "storage-${var.project}-${var.env}-name"
  value        = azurerm_storage_account.wp_storage.name
  key_vault_id = var.key_vault_id
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "storage_account_key" {
  name         = "storage-${var.project}-${var.env}-key"
  value        = azurerm_storage_account.wp_storage.primary_access_key
  key_vault_id = var.key_vault_id
  tags         = var.tags
}

resource "azurerm_storage_account" "fileshare" {
  name                     = "filesharest${var.project}${var.location_short}"
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Premium"
  account_kind             = "FileStorage"
  account_replication_type = "ZRS"

  lifecycle {
    prevent_destroy = true
  }
  tags = var.tags
}

resource "azurerm_storage_account" "snapshot" {
  name                     = "snapshotst${var.project}${var.location_short}"
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  lifecycle {
    prevent_destroy = true
  }
  tags = var.tags
}

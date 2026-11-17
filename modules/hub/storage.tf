resource "azurerm_storage_account" "fileshare" {
  name                     = "filesharest${var.project}${var.location_short}"
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Premium"
  account_kind             = "FileStorage"
  account_replication_type = "ZRS"

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = var.authorized_ip_range
    virtual_network_subnet_ids = concat([azurerm_subnet.snet-vm.id, azurerm_subnet.snet-endpoint.id], var.storage_subnet_ids)
  }

  #  lifecycle {
  #    prevent_destroy = true
  #  }
  tags = var.tags
}

resource "azurerm_storage_account" "snapshot" {
  name                     = "snapshotst${var.project}${var.location_short}"
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = var.authorized_ip_range
    virtual_network_subnet_ids = concat([azurerm_subnet.snet-vm.id, azurerm_subnet.snet-endpoint.id], var.storage_subnet_ids)
  }
  #  lifecycle {
  #    prevent_destroy = true
  #  }
  tags = var.tags
}

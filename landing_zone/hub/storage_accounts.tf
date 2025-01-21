resource "azurerm_resource_group" "st" {
  name     = "rg-storage-${var.project}"
  location = var.location
  tags     = var.tags
}

### Dev

resource "azurerm_storage_account" "st-aks-dev" {
  name                            = "st${var.project}aksdev"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.st.name
  account_tier                    = "Premium"
  account_replication_type        = "ZRS"
  account_kind                    = "FileStorage"
  allow_nested_items_to_be_public = "false"
  cross_tenant_replication_enabled= "true"
  network_rules {
    bypass                     = ["AzureServices", "Logging", "Metrics"]
    default_action             = "Deny"
    ip_rules                   = var.authorized_ip_range
    virtual_network_subnet_ids = [azurerm_subnet.snet-vm.id, azurerm_subnet.snet-endpoint.id, azurerm_subnet.snet-runner.id, azurerm_subnet.snet-db.id]
  }
  lifecycle {
    prevent_destroy = "false"
    ignore_changes  = [network_rules]
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "st-aks-dev-ep" {
  name                = "endpoint-${azurerm_storage_account.st-aks-dev.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.st.name
  subnet_id           = azurerm_subnet.snet-endpoint.id

  private_service_connection {
    name                           = "st-aks-connection"
    private_connection_resource_id = azurerm_storage_account.st-aks-dev.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  tags = var.tags
}

### Preprod

resource "azurerm_storage_account" "st-aks-preprod" {
  name                            = "st${var.project}akspreprod"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.st.name
  account_tier                    = "Premium"
  account_replication_type        = "ZRS"
  account_kind                    = "FileStorage"
  allow_nested_items_to_be_public = "false"
  cross_tenant_replication_enabled= "true"

  network_rules {
    bypass                     = ["AzureServices", "Logging", "Metrics"]
    default_action             = "Deny"
    ip_rules                   = var.authorized_ip_range
    virtual_network_subnet_ids = [azurerm_subnet.snet-vm.id, azurerm_subnet.snet-endpoint.id, azurerm_subnet.snet-runner.id, azurerm_subnet.snet-db.id]
  }

  lifecycle {
    prevent_destroy = "false"
    ignore_changes  = [network_rules]
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "st-aks-preprod-ep" {
  name                = "endpoint-${azurerm_storage_account.st-aks-preprod.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.st.name
  subnet_id           = azurerm_subnet.snet-endpoint.id

  private_service_connection {
    name                           = "st-aks-connection"
    private_connection_resource_id = azurerm_storage_account.st-aks-preprod.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  tags = var.tags
}

### Prod

resource "azurerm_storage_account" "st-aks-prod" {
  name                            = "st${var.project}aksprod"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.st.name
  account_tier                    = "Premium"
  account_replication_type        = "ZRS"
  account_kind                    = "FileStorage"
  allow_nested_items_to_be_public = "false"
  cross_tenant_replication_enabled= "true"

  network_rules {
    bypass                     = ["AzureServices", "Logging", "Metrics"]
    default_action             = "Deny"
    ip_rules                   = var.authorized_ip_range
    virtual_network_subnet_ids = [azurerm_subnet.snet-vm.id, azurerm_subnet.snet-endpoint.id, azurerm_subnet.snet-runner.id, azurerm_subnet.snet-db.id]
  }
  lifecycle {
    prevent_destroy = "false"
    ignore_changes  = [network_rules]
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "st-aks-prod-ep" {
  name                = "endpoint-${azurerm_storage_account.st-aks-prod.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.st.name
  subnet_id           = azurerm_subnet.snet-endpoint.id

  private_service_connection {
    name                           = "st-aks-connection"
    private_connection_resource_id = azurerm_storage_account.st-aks-prod.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  tags = var.tags
}

### Snapshots

resource "azurerm_storage_account" "st-snapshot" {
  name                            = "st${var.project}snapshot"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.st.name
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  allow_nested_items_to_be_public = "false"
  cross_tenant_replication_enabled= "true"

  network_rules {
    bypass                     = ["AzureServices", "Logging", "Metrics"]
    default_action             = "Deny"
    ip_rules                   = var.authorized_ip_range
    virtual_network_subnet_ids = [azurerm_subnet.snet-vm.id, azurerm_subnet.snet-endpoint.id, azurerm_subnet.snet-runner.id, azurerm_subnet.snet-db.id]
  }
  lifecycle {
    prevent_destroy = "false"
    ignore_changes  = [network_rules]
  }
  tags = var.tags
}
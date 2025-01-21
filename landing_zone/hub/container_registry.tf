resource "azurerm_container_registry" "cr" {
  name                = "cr${var.project}${var.env}${var.location_short}"
  resource_group_name = var.rgname
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = "true"
  retention_policy_in_days = "1"
  depends_on = [
    azurerm_virtual_network.vnet
  ]
  lifecycle {
    prevent_destroy = "true"
  }
  /*
  network_rule_set {
    default_action = "Deny"
    ip_rule {
      action   = "Allow"
      ip_range = "198.51.100.5/32"
    }
    virtual_network {
      action = "Allow"
      subnet_id = azurerm_subnet.snet-vm.id
    }
  } */

  tags = var.tags
}

resource "azurerm_private_endpoint" "cr-ep" {
  name                = "endpoint-${azurerm_container_registry.cr.name}"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.snet-endpoint.id

  private_service_connection {
    name                           = "cr-connection"
    private_connection_resource_id = azurerm_container_registry.cr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  tags = var.tags
}
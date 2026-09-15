resource "azurerm_container_registry" "cr" {
  name                = "cr${var.project}${var.env}${var.location_short}"
  resource_group_name = var.rgname
  location            = var.location
  sku                 = "Premium"
  # Managed-identity pull (see modules/aks/aks_identity.tf's acr-role
  # assignment) replaces the admin credentials - no static registry
  # password for the app repo's imagePullSecret to carry.
  admin_enabled = "false"

  retention_policy_in_days = 1

  depends_on = [
    azurerm_virtual_network.vnet
  ]
  lifecycle {
    prevent_destroy = false
  }

  # The provider version pinned here (azurerm ~> 4.0) dropped
  # network_rule_set's virtual_network/subnet support entirely - ip_rule is
  # the only public-network option left. AKS reaches the registry over the
  # private endpoint below instead (a separate access path from this
  # firewall - private-link traffic bypasses network_rule_set entirely),
  # so this rule only needs to keep covering direct public access, e.g.
  # from your own machine.
  network_rule_set {
    default_action = "Deny"

    ip_rule {
      action   = "Allow"
      ip_range = "${var.authorized_ip_range[0]}/32"
    }
  }
  tags = var.tags
}

resource "azurerm_private_dns_zone" "acr-dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.rgname
  tags                = var.tags
  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr-hub-link" {
  name                  = "acr-hub-link-${var.project}-${var.env}-${var.location_short}"
  private_dns_zone_name = azurerm_private_dns_zone.acr-dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = var.rgname
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "acr-pe" {
  name                = "pe-acr-${var.project}-${var.env}-${var.location_short}"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.snet-endpoint.id

  private_service_connection {
    name                           = "psc-acr-${var.project}-${var.env}-${var.location_short}"
    private_connection_resource_id = azurerm_container_registry.cr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "acr-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr-dns.id]
  }

  tags = var.tags
}

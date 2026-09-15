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
  # all that's left. VNet-scoped access now needs a private endpoint
  # (Premium SKU supports it) instead; not built out here since it needs
  # cross-VNet DNS resolution to the AKS VNet as well (see
  # modules/aks/aks_network.tf's aks-link for the equivalent MySQL pattern)
  # - tracked as a follow-up rather than half-built in this pass.
  network_rule_set {
    default_action = "Deny"

    ip_rule {
      action   = "Allow"
      ip_range = "${var.authorized_ip_range[0]}/32"
    }
  }
  tags = var.tags
}

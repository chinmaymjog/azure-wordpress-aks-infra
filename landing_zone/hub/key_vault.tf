data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                      = "kv-${var.project}-${var.env}-${var.location_short}"
  location                  = var.location
  resource_group_name       = var.rgname
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = "true"

  depends_on = [
    azurerm_virtual_network.vnet
  ]

  lifecycle {
    prevent_destroy = "true"
  }
  /*
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.authorized_ip_range
    virtual_network_subnet_ids = [ azurerm_subnet.snet-vm.id, azurerm_subnet.snet-endpoint.id ]
  } */
  tags = var.tags

  contact {
    email = "maintainer@example.com"
  }
}

resource "azurerm_private_endpoint" "kv" {
  name                = "endpoint-${azurerm_key_vault.kv.name}"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = azurerm_subnet.snet-endpoint.id

  private_service_connection {
    name                           = "kv-connection"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}

resource "azurerm_role_assignment" "kv-role" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
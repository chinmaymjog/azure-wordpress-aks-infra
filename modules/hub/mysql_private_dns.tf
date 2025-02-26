resource "azurerm_private_dns_zone" "mysql-dns" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = var.rgname
  tags                = var.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub-link" {
  name                  = "hub-link-${var.project}-${var.env}-${var.location_short}"
  private_dns_zone_name = azurerm_private_dns_zone.mysql-dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = var.rgname
  tags                  = var.tags
}

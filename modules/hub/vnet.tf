resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project}-${var.env}-${var.location_short}"
  location            = var.location
  resource_group_name = var.rgname
  address_space       = var.vnet_ip_block

  lifecycle {
    prevent_destroy = true
  }
  tags = var.tags
}

resource "azurerm_network_security_group" "nsg-vm" {
  name                = "nsg-vm-${var.project}-${var.env}-${var.location_short}"
  location            = var.location
  resource_group_name = var.rgname

  security_rule {
    name                         = "WEB"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_ranges      = ["80", "443"]
    source_address_prefix        = "*"
    destination_address_prefixes = var.vm_subnet_prefixes
  }

  security_rule {
    name                         = "SSH"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_ranges      = ["22", "81"]
    source_address_prefixes      = var.authorized_ip_range
    destination_address_prefixes = var.vm_subnet_prefixes
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "nsg-runner" {
  name                = "nsg-runners-${var.project}-${var.env}-${var.location_short}"
  location            = var.location
  resource_group_name = var.rgname
  /*
  security_rule {
    name                       = "WEB"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80,443"
    source_address_prefix      = "*"
    destination_address_prefixes = var.subnet_prefixes
  } */
  tags = var.tags
}
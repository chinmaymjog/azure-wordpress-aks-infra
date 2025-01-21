resource "azurerm_subnet" "resources-snet" {
  name                 = "subnet-resources-${var.project}-${var.env}-${var.location_short}"
  resource_group_name  = azurerm_resource_group.rg_aks.name
  virtual_network_name = azurerm_virtual_network.aks-vent.name
  address_prefixes     = var.resources_subnet
  service_endpoints    = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
}

resource "azurerm_network_security_group" "resources-nsg" {
  name                = "resources-nsg-${var.project}-${var.env}-${var.location_short}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_aks.name

  security_rule {
    name                         = "Logstash"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_ranges      = ["1514"]
    source_address_prefix        = azurerm_public_ip.outbound-ip.ip_address
    destination_address_prefixes = var.resources_subnet
  }

  security_rule {
    name                         = "SSH"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_ranges      = ["22"]
    source_address_prefixes      = var.authorized_ip_range
    destination_address_prefixes = var.resources_subnet
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_asso_vm" {
  subnet_id                 = azurerm_subnet.resources-snet.id
  network_security_group_id = azurerm_network_security_group.resources-nsg.id
}

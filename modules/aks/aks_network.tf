# Define Networking for AKS
resource "azurerm_virtual_network" "aks-vent" {
  name                = "vnet-aks-${var.project}-${var.env}-${var.location_short}"
  address_space       = var.vnet
  location            = azurerm_resource_group.rg_aks.location
  resource_group_name = azurerm_resource_group.rg_aks.name
  lifecycle {
    prevent_destroy = "true"
  }
  tags = var.tags
}

resource "azurerm_subnet" "aks-snet" {
  name                 = "subnet-aks-${var.project}-${var.env}-${var.location_short}"
  resource_group_name  = azurerm_resource_group.rg_aks.name
  virtual_network_name = azurerm_virtual_network.aks-vent.name
  address_prefixes     = var.nodepool_subnet
  service_endpoints    = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
}

resource "azurerm_public_ip" "inbound-ip" {
  name                = "inbound-aks-${var.project}-${var.env}-${var.location_short}"
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = azurerm_resource_group.rg_aks.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "inbound-aks-${var.project}-${var.env}-${var.location_short}"
  lifecycle {
    prevent_destroy = "true"
  }
  tags = var.tags
}

resource "azurerm_public_ip" "outbound-ip" {
  name                = "outbound-aks-${var.project}-${var.env}-${var.location_short}"
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = azurerm_resource_group.rg_aks.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "outbound-aks-${var.project}-${var.env}-${var.location_short}"
  lifecycle {
    prevent_destroy = "true"
  }
  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks-link" {
  name                  = "aks-link-${var.project}-${var.env}-${var.location_short}"
  private_dns_zone_name = "privatelink.mysql.database.azure.com"
  virtual_network_id    = azurerm_virtual_network.aks-vent.id
  resource_group_name   = var.hub_rgname
  tags                  = var.tags
}
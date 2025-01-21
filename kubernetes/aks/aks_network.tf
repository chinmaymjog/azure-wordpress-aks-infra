# Define Networking for AKS
resource "azurerm_virtual_network" "aks-vent" {
  name                = "vnet-aks-${var.project}-${var.env}-${var.location_short}"
  address_space       = var.aks_vnet
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

resource "azurerm_virtual_hub_connection" "hub-network" {
  name                      = "aks-${var.project}-${var.env}-${var.location_short}-connection"
  virtual_hub_id            = var.vwan_id
  remote_virtual_network_id = azurerm_virtual_network.aks-vent.id

  depends_on = [
    azurerm_virtual_network.aks-vent
  ]
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

resource "azurerm_traffic_manager_azure_endpoint" "aks" {
  name               = "endpoint-aks-${var.project}-${var.env}-${var.location_short}"
  profile_id         = var.env == "prod" ? var.tm_prod_id : (var.env == "preprod" ? var.tm_preprod_id : (var.env == "dev" ? var.tm_dev_id : var.tm_lab_id))
  target_resource_id = azurerm_public_ip.inbound-ip.id
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

resource "azurerm_traffic_manager_profile" "tm-aks" {
  name                   = "tm-aks-${var.project}-${var.env}-${var.location_short}"
  resource_group_name    = var.tm_rgname
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "tm-aks-${var.project}-${var.env}-${var.location_short}"
    ttl           = 60
  }

  monitor_config {
    protocol = "TCP"
    port     = 80
    # path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
  lifecycle {
    prevent_destroy = "true"
  }
  tags = merge(var.tags,
  { "UsedFor" = "AKS-${var.env}" })
}

resource "azurerm_traffic_manager_azure_endpoint" "tm-aks-ep" {
  name               = "endpoint-aks-${var.project}-${var.env}-${var.location_short}"
  profile_id         = azurerm_traffic_manager_profile.tm-aks.id
  target_resource_id = azurerm_public_ip.inbound-ip.id
}

resource "azurerm_subnet" "snet-vm" {
  name                              = "snet-vm"
  resource_group_name               = var.rgname
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = var.vm_subnet_prefixes
  service_endpoints                 = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "snet-endpoint" {
  name                              = "snet-endpoint"
  resource_group_name               = var.rgname
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = var.endpoint_subnet_prefixes
  service_endpoints                 = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "snet-db" {
  name                              = "snet-db"
  resource_group_name               = var.rgname
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = var.db_subnet_prefixes
  service_endpoints                 = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
  private_endpoint_network_policies = "Enabled"
  delegation {
    name = "mysql-delegation"

    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "snet-runner" {
  name                              = "snet-runner"
  resource_group_name               = var.rgname
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = var.runner_subnet_prefixes
  service_endpoints                 = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
  private_endpoint_network_policies = "Enabled"
}
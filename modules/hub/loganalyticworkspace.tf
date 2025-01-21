resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 2
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-${var.project}-${var.env}-${var.location_short}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.location
  resource_group_name = var.rgname

  lifecycle {
    prevent_destroy = "true"
  }
  tags = var.tags
}

resource "azurerm_log_analytics_solution" "insight" {
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.rgname
  workspace_resource_id = azurerm_log_analytics_workspace.log.id
  workspace_name        = azurerm_log_analytics_workspace.log.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

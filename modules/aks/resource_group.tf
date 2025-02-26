resource "azurerm_resource_group" "rg_aks" {
  name     = "rg-aks-${var.project}-${var.env}-${var.location_short}"
  location = var.location
  lifecycle {
    prevent_destroy = true
  }
  tags = var.tags
}

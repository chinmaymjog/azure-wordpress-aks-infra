data "azurerm_image" "source_image" {
  resource_group_name = var.hub_rgname
  name                = "rockylinux-9"
}
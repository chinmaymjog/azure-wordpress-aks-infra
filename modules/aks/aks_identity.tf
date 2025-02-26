resource "azurerm_user_assigned_identity" "identity" {
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = var.location
  name                = "id-aks-${var.project}-${var.env}-${var.location_short}"
  lifecycle {
    prevent_destroy = "false"
  }
  tags = var.tags
}

data "azurerm_user_assigned_identity" "aks-agentpool" {
  name                = "${azurerm_kubernetes_cluster.aks.name}-agentpool"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
}

data "azurerm_container_registry" "acr" {
  name                = var.acrname
  resource_group_name = var.hub_rgname
}

# resource "azurerm_role_assignment" "rg-role" {
#   principal_id                     = azurerm_user_assigned_identity.identity.principal_id
#   role_definition_name             = "Contributor"
#   scope                            = azurerm_resource_group.rg_aks.id
#   skip_service_principal_aad_check = true
# }

# resource "azurerm_role_assignment" "acr-role" {
#   principal_id                     = data.azurerm_user_assigned_identity.aks-agentpool.principal_id
#   role_definition_name             = "AcrPull"
#   scope                            = data.azurerm_container_registry.acr.id
#   skip_service_principal_aad_check = true
#   lifecycle {
#     prevent_destroy = false
#     ignore_changes = [
#       principal_id,
#     ]
#   }
# }

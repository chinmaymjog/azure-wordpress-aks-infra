output "aks_rg" {
  value = azurerm_resource_group.rg_aks.name
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
}

output "aks_host" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config.0.host
}

output "aks_client_key" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key
}

output "aks_client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate
}

output "aks_cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate
}

output "ingress_public_ip" {
  value = azurerm_public_ip.inbound-ip.ip_address
}

output "outbound_public_ip" {
  value = azurerm_public_ip.outbound-ip.ip_address
}

output "aks_vnet" {
  value = azurerm_virtual_network.aks-vent.name
}
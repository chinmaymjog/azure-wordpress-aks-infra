output "aks_rg" {
  value = azurerm_resource_group.rg_aks.name
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

# Cluster-admin credentials. Not needed for day-to-day access - the cluster
# has Azure AD RBAC enabled (azure_active_directory_role_based_access_control
# in aks.tf), so `az aks get-credentials` + `kubelogin`, or `az aks command
# invoke` from CI, are the normal paths in. Kept (marked sensitive) as a
# break-glass fallback only.
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive = true
}

output "aks_host" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config[0].host
  sensitive = true
}

output "aks_client_key" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config[0].client_key
  sensitive = true
}

output "aks_client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config[0].client_certificate
  sensitive = true
}

output "aks_cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config[0].cluster_ca_certificate
  sensitive = true
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
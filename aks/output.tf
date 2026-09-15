output "ingress_public_ip" {
  value = module.aks.ingress_public_ip
}

output "outbound_public_ip" {
  value = module.aks.outbound_public_ip
}

output "aks_name" {
  value = module.aks.aks_name
}

output "aks_rg" {
  value = module.aks.aks_rg
}
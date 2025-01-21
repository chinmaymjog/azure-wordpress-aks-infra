output "ingress_public_ip" {
  value = module.aks.ingress_public_ip
}

output "outbound_public_ip" {
  value = module.aks.outbound_public_ip
}

output "logstash_public_ip" {
  value = module.aks.logstash_ip
}
module "aks" {
  source                   = "../modules/aks"
  project                  = var.project
  env                      = var.env
  location                 = var.location
  location_short           = var.location_short
  username                 = var.username
  agent_count              = var.agent_count
  node_vmsize              = var.node_vmsize
  ssh_pvt_key              = file("../k8s")
  ssh_keys                 = file("../k8s.pub")
  authorized_ip_range      = formatlist("%s/32", flatten([var.authorized_ip_range]))
  os_disk_size_gb          = var.os_disk_size_gb
  os_disk_type             = var.os_disk_type
  node_pools               = var.node_pools
  kubernetes_version       = var.kubernetes_version
  acrname                  = data.terraform_remote_state.hub.outputs.acrname
  log_id                   = data.terraform_remote_state.hub.outputs.log_id
  vnet                     = var.vnet
  nodepool_subnet          = var.nodepool_subnet
  dns_service_ip           = var.dns_service_ip
  service_cidr             = var.service_cidr

  key_vault_id             = data.terraform_remote_state.hub.outputs.key_vault_id
  resources_subnet         = var.resources_subnet
  hub_rgname               = var.hub_rgname

  tags = {
    "Project"     = var.project,
    "Environment" = var.env,
    "Location"    = var.location,
  }
}

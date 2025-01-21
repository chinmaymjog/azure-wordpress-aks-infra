module "aks" {
  source = "./aks"

  project                  = var.project
  env                      = var.aks_env
  location                 = var.location
  location_short           = var.location_short
  username                 = var.username
  agent_count              = var.agent_count
  node_vmsize              = var.node_vmsize
  ssh_pvt_key              = file("../k8s")
  ssh_keys                 = file("../k8s.pub")
  authorized_ip_range      = formatlist("%s/32", flatten([var.authorized_ip_range, var.vm_ips, var.runner_ips]))
  os_disk_size_gb          = var.os_disk_size_gb
  os_disk_type             = var.os_disk_type
  kubernetes_version       = var.kubernetes_version
  acrname                  = var.acrname
  log_id                   = var.log_id
  aks_vnet                 = var.aks_vnet
  nodepool_subnet          = var.nodepool_subnet
  dns_service_ip           = var.dns_service_ip
  service_cidr             = var.service_cidr
  kured_version            = var.kured_version
  kured_repository         = var.kured_repository
  ingress_nginx_version    = var.ingress_nginx_version
  ingress_nginx_repository = var.ingress_nginx_repository
  cert_manager_version     = var.cert_manager_version
  cert_manager_repository  = var.cert_manager_repository
  site24x7_repository      = var.site24x7_repository
  site24x7_device_key      = var.site24x7_device_key
  support_email            = var.support_email
  vwan_id                  = var.vwan_id
  tm_rgname                = var.tm_rgname
  tm_dev_id                = var.tm_dev_id
  tm_lab_id                = var.tm_lab_id
  tm_preprod_id            = var.tm_preprod_id
  tm_prod_id               = var.tm_prod_id
  key_vault_id             = var.key_vault_id
  enable_redis             = var.enable_redis
  redis_capacity_gb        = var.redis_capacity_gb
  redis_family             = var.redis_family
  redis_sku                = var.redis_sku
  resources_subnet         = var.resources_subnet

  enable_logstash = var.enable_logstash
  source_image_id = data.azurerm_image.source_image.id
  image_publisher = var.image_publisher
  image_offer     = var.image_offer
  image_sku       = var.image_sku
  osdisksize      = var.osdisksize
  vmsize          = var.vmsize
  hub_rgname      = var.hub_rgname
  rsv_vault_name  = var.rsv_vault_name
  bkp_policy_id   = var.bkp_policy_id

  tags = {
    "Project"     = var.project,
    "Environment" = var.aks_env,
    "Location"    = var.location,
    "Team"        = "Platform-Team",
    "Email"       = "maintainer@example.com"
    "AccountableDepartment" = "Engineering"
  }
}
module "hub" {
  source                   = "../modules/hub"
  rgname                   = var.hub_rgname
  location                 = var.hub_location
  env                      = var.hub_env
  location_short           = var.hub_location_short
  project                  = var.project
  vnet_ip_block            = var.vnet_ip_block
  endpoint_subnet_prefixes = var.endpoint_subnet_prefixes
  vm_subnet_prefixes       = var.vm_subnet_prefixes
  db_subnet_prefixes       = var.db_subnet_prefixes
  runner_subnet_prefixes   = var.runner_subnet_prefixes
  authorized_ip_range      = var.authorized_ip_range

  tags = {
    "Project"     = var.project,
    "Environment" = var.hub_env,
    "Location"    = var.hub_location,
  }
}

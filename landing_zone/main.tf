module "hub" {
  source                   = "./hub"
  rgname                   = var.hub_rgname
  location                 = var.hub_location
  env                      = var.hub_env
  location_short           = var.hub_location_short
  project                  = var.project
  vnet_ip_block            = var.vnet_ip_block
  vwan_ip_block            = var.vwan_ip_block
  endpoint_subnet_prefixes = var.endpoint_subnet_prefixes
  vm_subnet_prefixes       = var.vm_subnet_prefixes
  db_subnet_prefixes       = var.db_subnet_prefixes
  runner_subnet_prefixes   = var.runner_subnet_prefixes
  authorized_ip_range      = var.authorized_ip_range

  tags = {
    "Project"     = var.project,
    "Environment" = var.hub_env,
    "Location"    = var.hub_location,
    "Team"        = "Platform-Team",
    "Email"       = "maintainer@example.com"
    "AccountableDepartment" = "Engineering"
  }
}

module "database" {
  source = "./database"
  depends_on = [
    module.hub
  ]
  for_each            = var.database
  env                 = each.value.env
  db_enabled          = each.value.db_enabled
  dbadminuser         = each.value.dbadminuser
  dbsku               = each.value.dbsku
  dbsize              = each.value.dbsize
  dbversion           = each.value.dbversion
  location            = var.hub_location
  location_short      = var.hub_location_short
  project             = var.project
  authorized_ip_range = var.authorized_ip_range
  vnet_id             = module.hub.vnet_id
  subnet_id           = module.hub.db_subnet_id
  key_vault_id        = module.hub.key_vault_id
  log_id              = module.hub.log_analytics_workspace_id
  mysql_dns_zone_id   = module.hub.mysql_dns_zone_id
  tags = {
    "Project"     = var.project,
    "Environment" = each.value.env,
    "Location"    = var.hub_location,
    "Team"        = "Platform-Team",
    "Email"       = "maintainer@example.com"
    "AccountableDepartment" = "Engineering"
  }
}
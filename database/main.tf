module "database" {
  source                   = "../modules/database"
  env                      = var.env
  dbsku                    = var.dbsku
  dbsize                   = var.dbsize
  dbversion                = var.dbversion
  location                 = var.location
  location_short           = var.location_short
  project                  = var.project
  db_subnet_id             = data.terraform_remote_state.hub.outputs.db_subnet_id
  key_vault_id             = data.terraform_remote_state.hub.outputs.key_vault_id
  mysql_dns_zone_id        = data.terraform_remote_state.hub.outputs.mysql_dns_zone_id
  storage_account_tier     = var.storage_account_tier
  storage_replication_type = var.storage_replication_type

  tags = {
    "Project"     = var.project,
    "Environment" = var.env,
    "Location"    = var.location,
  }
}

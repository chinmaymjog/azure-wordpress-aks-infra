resource "random_password" "dbadminpassword" {
  length  = 16
  special = "true"
}

locals {
  dbadminuser = "${var.env}mysqladmin"
}

resource "azurerm_key_vault_secret" "db_user" {
  name         = "mysql-${var.project}-${var.env}-user"
  value        = local.dbadminuser
  key_vault_id = var.key_vault_id
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "db_secret" {
  name         = "mysql-${var.project}-${var.env}-secret"
  value        = random_password.dbadminpassword.result
  key_vault_id = var.key_vault_id
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "db_url" {
  name         = "mysql-${var.project}-${var.env}-url"
  value        = "${azurerm_mysql_flexible_server.mysql.name}.privatelink.mysql.database.azure.com"
  key_vault_id = var.key_vault_id
  tags         = var.tags
}

resource "azurerm_resource_group" "rg_database" {
  name     = "rg-database-${var.project}-${var.env}-${var.location_short}"
  location = "West Europe"
  tags     = var.tags
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                         = "mysql-${var.project}-${var.env}-${var.location_short}"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg_database.name
  administrator_login          = local.dbadminuser
  administrator_password       = random_password.dbadminpassword.result
  geo_redundant_backup_enabled = "true"
  sku_name                     = var.dbsku
  version                      = var.dbversion

  storage {
    auto_grow_enabled = "true"
    size_gb           = var.dbsize
  }
  backup_retention_days = "30"
  zone                  = "1"
  delegated_subnet_id   = var.db_subnet_id
  private_dns_zone_id   = var.mysql_dns_zone_id

  lifecycle {
    prevent_destroy = "true"
  }
  tags = var.tags
}

resource "azurerm_mysql_flexible_server_configuration" "require_secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.rg_database.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = "OFF"
}

resource "azurerm_mysql_flexible_server_configuration" "sql_generate_invisible_primary_key" {
  name                = "sql_generate_invisible_primary_key"
  resource_group_name = azurerm_resource_group.rg_database.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = "OFF"
}
resource "random_password" "dbadminpassword" {
  length  = 16
  special = "true"
  count   = var.db_enabled == "true" ? 1 : 0
}

resource "azurerm_key_vault_secret" "db_user" {
  name         = "mysql-${var.project}-${var.env}-user"
  value        = var.dbadminuser
  key_vault_id = var.key_vault_id
  count        = var.db_enabled == "true" ? 1 : 0
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "db_secret" {
  name         = "mysql-${var.project}-${var.env}-secret"
  value        = random_password.dbadminpassword[count.index].result
  key_vault_id = var.key_vault_id
  count        = var.db_enabled == "true" ? 1 : 0
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "db_url" {
  name         = "mysql-${var.project}-${var.env}-url"
  value        = "${azurerm_mysql_flexible_server.mysql[count.index].name}.privatelink.mysql.database.azure.com"
  key_vault_id = var.key_vault_id
  count        = var.db_enabled == "true" ? 1 : 0
  tags         = var.tags
}

resource "azurerm_resource_group" "rg_database" {
  name     = "rg-database-${var.project}-${var.env}-${var.location_short}"
  location = "West Europe"
  count    = var.db_enabled == "true" ? 1 : 0
  tags     = var.tags
}

/*
resource "azurerm_mariadb_server" "mariadb" {
  name                = "mariadb-${var.project}-${var.env}-${var.location_short}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_database[count.index].name
  count               = var.db_enabled == "true" ? 1 : 0

  administrator_login          = var.dbadminuser
  administrator_login_password = random_password.dbadminpassword[count.index].result

  sku_name   = var.dbsku
  storage_mb = var.dbsize
  version    = var.dbversion

  auto_grow_enabled             = true
  backup_retention_days         = 30
  geo_redundant_backup_enabled  = false # Make it true in production 
  public_network_access_enabled = true
  ssl_enforcement_enabled       = false

  lifecycle {
    prevent_destroy = "true"
  }
} */



resource "azurerm_mysql_flexible_server" "mysql" {
  name                         = "mysql-${var.project}-${var.env}-${var.location_short}"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg_database[count.index].name
  count                        = var.db_enabled == "true" ? 1 : 0
  administrator_login          = var.dbadminuser
  administrator_password       = random_password.dbadminpassword[count.index].result
  geo_redundant_backup_enabled = "true"
  sku_name                     = var.dbsku
  version                      = var.dbversion

  storage {
    auto_grow_enabled = "true"
    size_gb           = var.dbsize
  }
  backup_retention_days = "30"
  zone                  = "3"
  delegated_subnet_id   = var.subnet_id
  private_dns_zone_id   = var.mysql_dns_zone_id

  lifecycle {
    prevent_destroy = "true"
  }
  tags = var.tags
}

resource "azurerm_mysql_flexible_server_configuration" "require_secure_transport" {
  count               = var.db_enabled == "true" ? 1 : 0
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.rg_database[count.index].name
  server_name         = azurerm_mysql_flexible_server.mysql[count.index].name
  value               = "OFF"
}

resource "azurerm_mysql_flexible_server_configuration" "sql_generate_invisible_primary_key" {
  count               = var.db_enabled == "true" ? 1 : 0
  name                = "sql_generate_invisible_primary_key"
  resource_group_name = azurerm_resource_group.rg_database[count.index].name
  server_name         = azurerm_mysql_flexible_server.mysql[count.index].name
  value               = "OFF"
}
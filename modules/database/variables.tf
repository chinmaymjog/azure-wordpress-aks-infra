variable "project" {
  description = "Project name"
}

variable "env" {
  description = "Environment"
}

variable "location" {
  description = "Azure region to create resources"
}

variable "location_short" {
  description = "Short for Azure Region"
}

variable "dbsku" {
  description = "database sku"
}
variable "dbsize" {
  description = "database szie in MB"
}
variable "dbversion" {
  description = "database version"
}

variable "db_subnet_id" {
  description = "DB Subnet id "
}

variable "key_vault_id" {
  description = "Id of key vault"
}

variable "tags" {
  description = "Tags"
}

variable "mysql_dns_zone_id" {
  description = "ID of mysql private DNS zone"
}
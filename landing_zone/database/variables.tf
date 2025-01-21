variable "project" {
  description = "Project name"
}

variable "env" {
  description = "Environment"
}

variable "db_enabled" {
  description = "boolean to decide runners creation"
}

variable "location" {
  description = "Azure region to create resources"
}

variable "location_short" {
  description = "Short for Azure Region"
}

variable "dbadminuser" {
  description = "admin user for database"
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

variable "authorized_ip_range" {
  description = "IP range to whitelist"
}

variable "vnet_id" {
  description = "VNET ID"
}

variable "subnet_id" {
  description = "DB Subnet id "
}

variable "key_vault_id" {
  description = "Id of key vault"
}

variable "tags" {
  description = "Tags"
}

variable "log_id" {
  description = "ID of log analytics workspace"
}

variable "mysql_dns_zone_id" {
  description = "ID of mysql private DNS zone"
}
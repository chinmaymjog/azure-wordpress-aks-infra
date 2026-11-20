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

variable "storage_account_tier" {
  description = "Tier of the storage account (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Replication type for the storage account"
  type        = string
  default     = "LRS"
}

variable "mysql_dns_zone_id" {
  description = "ID of mysql private DNS zone"
}
variable "authorized_ip_range" {
  description = "Public IPs allowed to reach the WordPress storage account (scripts, uploads)"
  type        = list(string)
  default     = []
}

variable "storage_subnet_ids" {
  description = "Subnet IDs allowed to reach the WordPress storage account; add the AKS node subnet ID here so pods can mount the file share. Must have the Microsoft.Storage service endpoint."
  type        = list(string)
  default     = []
}

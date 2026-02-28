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

variable "mysql_dns_zone_id" {
  description = "ID of mysql private DNS zone"
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

variable "hub_location" {
  description = "Hub location"
  default     = ""
}

variable "hub_location_short" {
  description = "Hub location short name"
  default     = ""
}

variable "hub_env" {
  description = "Hub environment"
  default     = ""
}

variable "hub_rgname" {
  description = "Hub resource group"
  default     = ""
}

variable "tf_staccount" {
  description = "TF State storage"
  default     = ""
}

variable "tf_container" {
  description = "TF State container"
  default     = ""
}


variable "kubernetes_version" {
  description = "K8s version"
  default     = ""
}
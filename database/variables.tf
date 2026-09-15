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

variable "hub_rgname" {
  description = "Resource group for Azure container registry"
}

# Global variables passed from global.auto.tfvars
variable "hub_location_short" {
  description = "Hub location short name"
  default     = ""
}

variable "hub_env" {
  description = "Hub environment"
  default     = ""
}

variable "tf_staccount" {
  description = "Storage account for hub remote state"
  default     = ""
}

variable "tf_container" {
  description = "Container for hub remote state"
  default     = ""
}
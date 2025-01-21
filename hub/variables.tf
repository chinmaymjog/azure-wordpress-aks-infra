

variable "project" {
  description = "Project name"
}

variable "hub_location" {
  description = "Azure region to create resources"
}

variable "hub_location_short" {
  description = "Short for Azure Region"
}

variable "hub_env" {
  description = "Environment"
}

variable "hub_rgname" {
  description = "Resource Group Name"
}

variable "vnet_ip_block" {
  description = "IP block for VNET"
}

variable "endpoint_subnet_prefixes" {
  description = "Endpoints subnet block"
}

variable "vm_subnet_prefixes" {
  description = "VM subnet block"
}

variable "db_subnet_prefixes" {
  description = "DB subnet block"
}

variable "runner_subnet_prefixes" {
  description = "Runner subnet block"
}

variable "username" {
  description = "VM sudo user"
}

variable "authorized_ip_range" {
  description = "IP range to whitelist"
}

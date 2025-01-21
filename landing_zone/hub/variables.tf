

variable "project" {
  description = "Project name"
}

variable "location" {
  description = "Azure region to create resources"
}

variable "location_short" {
  description = "Short for Azure Region"
}

variable "env" {
  description = "Environment"
}

variable "rgname" {
  description = "Resource Group Name"
}

variable "vnet_ip_block" {
  description = "IP block for VNET"
}

variable "vwan_ip_block" {
  description = "IP block for Virtual WAN"
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


variable "authorized_ip_range" {
  description = "IP range to whitelist"
}

variable "tags" {

}
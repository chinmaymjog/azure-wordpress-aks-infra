

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

variable "vmsize" {
  description = "VM size"
}

variable "osdisksize" {
  description = "Datadisk size in GB"
}

variable "datadisksize" {
  description = "Datadisk size in GB"
}

variable "username" {
  description = "VM sudo user"
}

variable "dbadminuser" {
  default = "k8sadmin"
}

variable "authorized_ip_range" {
  description = "IP range to whitelist"
}

variable "vm" {
  description = "Map of VMs to configure"
  type        = map(any)
}

variable "runners" {
  description = "Map of runners to configure"
  type        = map(any)
}

variable "database" {
  description = "Map of database to configure"
  type        = map(any)
}

variable "image_publisher" {
  description = "OS image publisher"
}

variable "image_offer" {
  description = "OS image offer"
}

variable "image_sku" {
  description = "OS image sku"
}
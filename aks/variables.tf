variable "project" {
  description = "Project name"
}

variable "env" {
  description = "AKS environment"
}

variable "location" {
  description = "Azure region to create resources"
}

variable "location_short" {
  description = "Short for Azure Region"
}

variable "agent_count" {
  description = "Number of agents in agentpool"
}

variable "username" {
  description = "VM sudo user"
}

variable "node_vmsize" {
  description = "VM size"
}

variable "authorized_ip_range" {
  description = "IP range to whitelist"
}

variable "os_disk_size_gb" {
  description = "OS Disk size for agent nodes"
}

variable "os_disk_type" {
  description = "OS Disk type for agent nodes"
}

variable "node_pools" {
  description = "Map of additional node pools to create"
  type = map(object({
    vm_size              = string
    node_count           = optional(number)
    auto_scaling_enabled = optional(bool)
    min_count            = optional(number)
    max_count            = optional(number)
    os_disk_size_gb      = optional(number)
    os_disk_type         = optional(string)
  }))
  default = {}
}

variable "kubernetes_version" {
  description = "Kubernetes version to deploy"
}



variable "vnet" {
  description = "K8S VNET address space"
}

variable "nodepool_subnet" {
  description = "K8S SUBNET address prefixes"
}

variable "dns_service_ip" {
  description = "K8S DNS Service IP"
}

variable "service_cidr" {
  description = "K8S service CIDR"
}

variable "acrname" {
  description = "Azure container registry name"
}

variable "hub_rgname" {
  description = "Resource group for Azure container registry"
}

variable "log_id" {
  description = "Log analytic workspace id"
}

variable "key_vault_id" {
  description = "Id of key vault"
}

variable "resources_subnet" {
  description = "Subnet for redis"
}

variable "tf_staccount" {
  description = "Storage account for hub remote state"
}

variable "tf_container" {
  description = "Container for hub remote state"
}

variable "hub_env" {
  description = "Hub environment"
}

variable "hub_location_short" {
  description = "Hub location short name"
}
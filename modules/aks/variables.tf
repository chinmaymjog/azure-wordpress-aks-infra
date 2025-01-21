variable "project" {
  description = "Project name"
}

variable "env" {
  description = "Project environment"
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

variable "ssh_pvt_key" {
  description = "SSH private key for authentication"
}

variable "ssh_keys" {
  description = "SSH public key for authentication"
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

variable "kubernetes_version" {
  description = "Kubernetes version to deploy"
}

variable "acrname" {
  description = "Azure container registry name"
}

variable "log_id" {
  description = "Log analytic workspace id"
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

variable "kured_version" {
  description = "Kured chart version"
}

variable "kured_repository" {
  description = "Kured Repository"
}

variable "ingress_nginx_version" {
  description = "Nginx ingress chart version"
}

variable "ingress_nginx_repository" {
  description = "Nginx ingress Repository"
}

variable "cert_manager_version" {
  description = "cert-manager chart version"
}

variable "cert_manager_repository" {
  description = "cert-manager Repository"
}

variable "support_email" {
  description = "email address for letsencrypt expiration email"
}

variable "key_vault_id" {
  description = "Id of key vault"
}

variable "tags" {
  description = "Tags"
}

variable "resources_subnet" {
  description = "Subnet for redis"
}

variable "hub_rgname" {
  description = "Resource group for hub"
}
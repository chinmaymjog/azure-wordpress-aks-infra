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

variable "vmsize" {
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

variable "vwan_id" {
  description = "Id for VWAN in hub"
}
# Azure CNI Networking for K8S

variable "aks_vnet" {
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

variable "site24x7_repository" {
  description = "site24x7 Repository"
}

variable "site24x7_device_key" {
  description = "site24x7 auth key"
}

variable "support_email" {
  description = "email address for letsencrypt expiration email"
}

variable "tm_rgname" {
  description = "Resource group to create traffic manager"
}

variable "tm_dev_id" {
  description = "Traffic manager profile ID for dev"
}

variable "tm_lab_id" {
  description = "Traffic manager profile ID for lab"
}

variable "tm_preprod_id" {
  description = "Traffic manager profile ID for preprod"
}

variable "tm_prod_id" {
  description = "Traffic manager profile ID for prod"
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

variable "enable_redis" {
  description = "boolen to create redis"
}

variable "redis_capacity_gb" {
  description = "Redis capacity in GB"
}

variable "redis_family" {
  description = "Redis family"
}

variable "redis_sku" {
  description = "Redis SKU"
}

variable "source_image_id" {
  description = "Azure resource id for OS image"
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

variable "osdisksize" {
  description = "Datadisk ize in GB"
}

variable "rsv_vault_name" {
  description = "Recovery Service Vault Name"
}

variable "bkp_policy_id" {
  description = "Backup policy ID"
}

variable "hub_rgname" {
  description = "Resource group for hub"
}

variable "enable_logstash" {
  description = "boolen to create logstash vm"
}
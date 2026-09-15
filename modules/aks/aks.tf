# Creation of AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.project}-${var.env}-${var.location_short}"
  location            = azurerm_resource_group.rg_aks.location
  resource_group_name = azurerm_resource_group.rg_aks.name
  dns_prefix          = "aks-${var.env}"

  lifecycle {
    prevent_destroy = false
  }

  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = var.ssh_keys
    }
  }

  # node_os_channel_upgrade   = "NodeImage"

  default_node_pool {
    name = "${var.env}01"
    #node_count           = var.agent_count
    auto_scaling_enabled = true
    max_count            = var.agent_count
    min_count            = 1
    vm_size              = var.node_vmsize
    os_disk_size_gb      = var.os_disk_size_gb
    os_disk_type         = var.os_disk_type
    orchestrator_version = var.kubernetes_version
    vnet_subnet_id       = azurerm_subnet.aks-snet.id
    max_pods             = 110

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  oms_agent {
    log_analytics_workspace_id = var.log_id
  }

  microsoft_defender {
    log_analytics_workspace_id = var.log_id
  }

  api_server_access_profile {
    authorized_ip_ranges = var.authorized_ip_range
  }

  kubernetes_version = var.kubernetes_version

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "azure"
    dns_service_ip    = var.dns_service_ip
    service_cidr      = var.service_cidr
    load_balancer_profile {
      outbound_ip_address_ids = [azurerm_public_ip.outbound-ip.id]
    }
  }

  role_based_access_control_enabled = "true"
  azure_policy_enabled              = "true"
  azure_active_directory_role_based_access_control {
    admin_group_object_ids = []
    azure_rbac_enabled     = true
  }
  tags = var.tags
}

resource "azurerm_key_vault_secret" "aks_secret" {
  name         = "aks-${var.project}-${var.env}-${var.location_short}-secret"
  value        = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  key_vault_id = var.key_vault_id
  tags         = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "additional_node_pools" {
  for_each = var.node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = each.value.vm_size
  node_count            = lookup(each.value, "node_count", null)
  auto_scaling_enabled  = lookup(each.value, "auto_scaling_enabled", true)
  min_count             = lookup(each.value, "min_count", 1)
  max_count             = lookup(each.value, "max_count", 3)
  os_disk_size_gb       = lookup(each.value, "os_disk_size_gb", 64)
  os_disk_type          = lookup(each.value, "os_disk_type", "Ephemeral")
  vnet_subnet_id        = azurerm_subnet.aks-snet.id
  max_pods              = 250

  tags = var.tags
}

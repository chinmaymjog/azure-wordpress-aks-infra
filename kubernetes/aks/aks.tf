# Creation of AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.project}-${var.env}-${var.location_short}"
  location            = azurerm_resource_group.rg_aks.location
  resource_group_name = azurerm_resource_group.rg_aks.name
  dns_prefix          = "aks-${var.env}"

  lifecycle {
    prevent_destroy = "true"
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
    enable_auto_scaling  = true
    max_count            = var.agent_count
    min_count            = 1
    vm_size              = var.node_vmsize
    os_disk_size_gb      = var.os_disk_size_gb
    os_disk_type         = var.os_disk_type
    orchestrator_version = var.kubernetes_version
    vnet_subnet_id       = azurerm_subnet.aks-snet.id
    max_pods             = 110
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
    #network_policy     = "azure"         
    #docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip = var.dns_service_ip
    service_cidr   = var.service_cidr
    load_balancer_profile {
      outbound_ip_address_ids = [azurerm_public_ip.outbound-ip.id]
    }
  }

  azure_active_directory_role_based_access_control {
    managed            = "true"
    azure_rbac_enabled = "true"
  }
  azure_policy_enabled = "true"

  tags = var.tags
}

resource "local_file" "azurek8s" {
  content         = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  filename        = "./azurek8s"
  file_permission = "0644"
}

resource "azurerm_key_vault_secret" "aks_secret" {
  name         = "aks-${var.project}-${var.env}-${var.location_short}-secret"
  value        = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  key_vault_id = var.key_vault_id
  tags         = var.tags
}

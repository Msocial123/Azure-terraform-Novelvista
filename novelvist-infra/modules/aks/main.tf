resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  private_cluster_enabled = var.private_cluster_enabled

  ############################
  # Default (System) Node Pool
  ############################
  default_node_pool {
    name            = var.system_node_pool.name
    vm_size         = var.system_node_pool.vm_size
    os_disk_size_gb = var.system_node_pool.os_disk_size_gb
    type            = var.system_node_pool.type

    #enable_auto_scaling = var.enable_auto_scaling
    node_count = var.enable_auto_scaling ? null : var.system_node_pool.node_count

    vnet_subnet_id = var.aks_subnet_id
    #enable_node_public_ip = var.enable_node_public_ip

    node_labels = {
      nodepool-type = "system"
      environment   = var.environment
      critical      = "true"
    }

    #node_taints = var.node_taints
  }

  ############################
  # Identity
  ############################
  identity {
    type = "SystemAssigned"
  }

  ############################
  # Linux Profile
  ############################
  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  ############################
  # Network Profile
  ############################
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  ############################
  # Tags
  ############################
  tags = {
    company     = var.company_name
    environment = var.environment
    suffix      = var.suffix
  }
}

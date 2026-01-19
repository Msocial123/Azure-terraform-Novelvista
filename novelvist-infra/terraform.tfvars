# Azure Configuration
#subscription_id                 = "your subscription_id"
resource_group_name             = "azureskf-T"
environment                     = "dev"
project_name                    = "novelvista"
company_name                    = "NovelVista Pvt Ltd"
suffix                          = "nv123"
resource_provider_registrations = "none"

tags = {
  Project     = "NovelVista"
  Environment = "Development"
  ManagedBy   = "Terraform"
  CostCenter  = "IT-001"
  Department  = "Engineering"
}

# VNet Configuration
vnet_name = "novelvista-vnet"

# Core Configuration
vnet_address_space = ["192.168.0.0/16"]

# Subnets Configuration
subnets = {
  "public" = {
    name              = "public-subnet"
    address_prefixes  = ["192.168.1.0/24"]
    service_endpoints = []
  }
  "private" = {
    name              = "private-subnet"
    address_prefixes  = ["192.168.2.0/24"]
    service_endpoints = []
  }
  "database" = {
    name              = "database-subnet"
    address_prefixes  = ["192.168.3.0/24"]
    service_endpoints = ["Microsoft.Sql"]
  }
}
# AKS Configuration
aks_config = {
  cluster_name            = "novelvista-aks"
  dns_prefix              = "novelvistaaks"
  kubernetes_version      = "1.33.5"
  private_cluster_enabled = true

  system_node_pool = {
    name                = "systempool"
    node_count          = 1
    vm_size             = "Standard_DS2_v2"
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
  }

  user_node_pools = [
    {
      name                = "userpool1"
      node_count          = 2
      vm_size             = "Standard_DS2_v2"
      os_disk_size_gb     = 30
      os_type             = "Linux"
      os_sku              = "Ubuntu"
      enable_auto_scaling = false
    },
    {
      name                = "userpool2"
      node_count          = 2
      vm_size             = "Standard_DS4_v2"
      os_disk_size_gb     = 50
      os_type             = "Linux"
      os_sku              = "Ubuntu"
      enable_auto_scaling = false
    }
  ]
}

enable_auto_scaling   = false
enable_node_public_ip = false

node_taints = [
  "CriticalAddonsOnly=true:NoSchedule"
]
# Database Configuration
database_config = {
  server_name            = "novelvista-psql"
  administrator_login    = "psqladmin"
  administrator_password = "" # Leave empty to auto-generate
  database_name          = "novelvistadb"
  sku_name               = "GP_Standard_D2s_v3"
  storage_mb             = 32768
  version                = "13"
}

# VM Configuration
vm_config = {
  vm_name           = "novelvista-vm"
  vm_size           = "Standard_B2s"
  admin_username    = "azureuser"
  public_ip_enabled = true
  custom_data_file  = "" # Optional: Path to cloud-init script

  os_image = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }
}

# SSH Configuration
ssh_config = {
  algorithm = "RSA"
  rsa_bits  = 4096
  key_name  = "novelvista-vm-key"
}
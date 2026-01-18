data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

module "ssh_key" {
  source    = "./modules/ssh"
  key_name  = var.ssh_config.key_name
  algorithm = var.ssh_config.algorithm
  rsa_bits  = var.ssh_config.rsa_bits
}

module "vnet" {
  source = "./modules/vnet"

  company_name = var.company_name
  environment  = var.environment
  suffix       = var.suffix

  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  tags                = var.tags
}


module "subnets" {
  source              = "./modules/subnet"
  vnet_name           = module.vnet.vnet_name
  vnet_id             = module.vnet.vnet_id
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  subnets             = var.subnets

  depends_on = [module.vnet]
}

module "aks" {
  source = "./modules/aks"

  # REQUIRED METADATA (YOU MISSED THESE)
  company_name = var.company_name
  environment  = var.environment
  suffix       = var.suffix

  # AKS FLAGS
  enable_auto_scaling   = var.enable_auto_scaling
  enable_node_public_ip = var.enable_node_public_ip
  node_taints           = var.node_taints

  # AKS CORE
  cluster_name       = var.aks_config.cluster_name
  dns_prefix         = var.aks_config.dns_prefix
  kubernetes_version = var.aks_config.kubernetes_version

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  private_cluster_enabled = var.aks_config.private_cluster_enabled
  aks_subnet_id           = module.subnets.subnet_ids["private"]

  system_node_pool = var.aks_config.system_node_pool
  user_node_pools  = var.aks_config.user_node_pools

  ssh_public_key = module.ssh_key.public_key_openssh
}


module "database" {
  source = "./modules/database"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  server_name            = var.database_config.server_name
  administrator_login    = var.database_config.administrator_login
  administrator_password = var.database_config.administrator_password
  database_name          = var.database_config.database_name
  sku_name               = var.database_config.sku_name
  storage_mb             = var.database_config.storage_mb
  version                = var.database_config.version

  db_subnet_id = module.subnets.subnet_ids["database"]
  vnet_id      = module.vnet.vnet_id
  tags         = var.tags
}

module "vm" {
  source = "./modules/vm"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  vm_name        = var.vm_config.vm_name
  vm_size        = var.vm_config.vm_size
  admin_username = var.vm_config.admin_username
  ssh_public_key = module.ssh_key.public_key_openssh

  subnet_id         = module.subnets.subnet_ids["public"]
  public_ip_enabled = var.vm_config.public_ip_enabled
  os_image          = var.vm_config.os_image
  os_disk           = var.vm_config.os_disk

  tags = var.tags
}

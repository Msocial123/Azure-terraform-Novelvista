# 1. Create SSH Key
module "ssh_key" {
  source    = "./modules/ssh"
  key_name  = var.ssh_config.key_name
  algorithm = var.ssh_config.algorithm
  rsa_bits  = var.ssh_config.rsa_bits

  #resource_group_name = data.azurerm_resource_group.existing.name
  #location            = data.azurerm_resource_group.existing.location
}

# 2. Create Virtual Network
module "vnet" {
  source = "./modules/vnet"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  tags                = var.tags
}

# 3. Create Subnets (Public, Private, Database)
module "subnet" {
  source = "./modules/subnet"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  vnet_id             = module.vnet.vnet_id
  subnets             = var.subnets
  tags                = var.tags

  depends_on = [module.vnet]
}

# 4. Create Simple VMs with NEW module
module "computesimple" {
  source = "./modules/compute"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  tags                = var.tags
  ssh_public_key      = module.ssh_key.public_key_openssh

  # Simple subnet IDs
  public_subnet_id  = module.subnet.subnet_ids["public"]
  private_subnet_id = module.subnet.subnet_ids["private"]

  # VM configurations (all optional with defaults)
  public_vm_name      = "vm-public-01"
  public_vm_size      = "Standard_B1s"
  public_vm_username  = "student"
  public_vm_disk_type = "Standard_LRS"

  private_vm_name      = "vm-private-01"
  private_vm_size      = "Standard_B1s"
  private_vm_username  = "appuser"
  private_vm_disk_type = "Standard_LRS"

  depends_on = [module.subnet, module.ssh_key]
}
/*
# 5. Create PostgreSQL Flexible Server in Database Subnet
module "postgresql_flexible" {
  source = "./modules/postgresql_flexible"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  tags                = var.tags

  # Network configuration
  network_config = {
    vnet_id     = module.vnet.vnet_id
    subnet_id   = module.subnet.subnet_ids["database"]
    subnet_cidr = local.database_subnet_cidr
  }

  # Database configuration
  postgresql_config = local.postgresql_config

  # Allow connections from private subnet (where app VMs are)
  allowed_app_subnet_cidr = local.private_subnet_cidr

  # Allow connections from public subnet if needed
  allowed_public_subnet_cidr = local.public_subnet_cidr

  # Database extensions to install
  db_extensions = var.postgresql_config.db_extensions

  depends_on = [
    module.subnet,
    module.vnet
  ]
}
*/
# 5. Create PostgreSQL Flexible Server with PUBLIC ACCESS
module "postgresql_flexible" {
  source = "./modules/postgresql_flexible"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  tags                = var.tags

  # Network configuration (OPTIONAL for public access)
  network_config = {
    vnet_id     = module.vnet.vnet_id
    subnet_id   = module.subnet.subnet_ids["database"]
    subnet_cidr = var.subnets["database"].address_prefixes[0]
  }

  # Database configuration
  postgresql_config = var.postgresql_config

  # Allow connections from private subnet (where app VMs are)
  allowed_app_subnet_cidr = var.subnets["private"].address_prefixes[0]

  # Optional: Allow connections from public subnet
  allowed_public_subnet_cidr = var.subnets["public"].address_prefixes[0]

  # For learning: allow all IPs (CAREFUL!)
  allow_all_ips = true

  # Database extensions
  db_extensions = var.postgresql_config.db_extensions

  # No depends_on needed for public access
  # depends_on = [module.subnet, module.compute]
}
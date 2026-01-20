/*
# ========== SSH OUTPUTS ==========
output "ssh_private_key" {
  description = "SSH private key (sensitive)"
  value       = module.ssh_key.private_key_pem
  sensitive   = true
}

output "ssh_public_key" {
  description = "SSH public key"
  value       = module.ssh_key.public_key_openssh
}

# ========== NETWORK OUTPUTS ==========
output "vnet_id" {
  description = "Virtual Network ID"
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = module.vnet.vnet_name
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = module.subnet.subnet_ids
}

output "subnet_cidrs" {
  description = "Subnet CIDR blocks"
  value       = { for k, v in var.subnets : k => v.address_prefixes[0] }
}

# ========== COMPUTE OUTPUTS ==========
output "public_vm_public_ips" {
  description = "Public IP addresses of public VMs"
  value       = module.compute.public_vm_public_ips
}

output "public_vm_private_ips" {
  description = "Private IP addresses of public VMs"
  value       = module.compute.public_vm_private_ips
}

output "private_vm_private_ips" {
  description = "Private IP addresses of private VMs"
  value       = module.compute.private_vm_private_ips
}

output "vm_ssh_commands" {
  description = "SSH commands to connect to VMs"
  value = {
    public_vms = [for i, ip in module.compute.public_vm_public_ips :
      "ssh ${var.vm_config.public.admin_username}@${ip} -i id_rsa"
    ]
  }
}


# ========== POSTGRESQL FLEXIBLE SERVER OUTPUTS ==========
output "postgresql_server_name" {
  description = "PostgreSQL Flexible Server name"
  value       = module.postgresql_flexible.postgresql_server_name
}

output "postgresql_server_id" {
  description = "PostgreSQL Flexible Server resource ID"
  value       = module.postgresql_flexible.postgresql_server_id
}

output "postgresql_server_fqdn" {
  description = "PostgreSQL Flexible Server fully qualified domain name"
  value       = module.postgresql_flexible.postgresql_server_fqdn
}

output "postgresql_database_name" {
  description = "PostgreSQL database name"
  value       = module.postgresql_flexible.postgresql_database_name
}

output "postgresql_administrator_login" {
  description = "PostgreSQL administrator login username"
  value       = module.postgresql_flexible.postgresql_administrator_login
}

output "postgresql_administrator_password" {
  description = "PostgreSQL administrator password (sensitive)"
  value       = module.postgresql_flexible.postgresql_administrator_password
  sensitive   = true
}

output "postgresql_connection_string" {
  description = "PostgreSQL connection strings (sensitive)"
  value       = module.postgresql_flexible.postgresql_connection_strings
  sensitive   = true
}

output "postgresql_private_dns_zone" {
  description = "PostgreSQL Private DNS Zone name"
  value       = module.postgresql_flexible.postgresql_private_dns_zone
}

output "postgresql_server_endpoint" {
  description = "PostgreSQL Server endpoint details"
  value = {
    host     = module.postgresql_flexible.postgresql_server_fqdn
    port     = 5432
    database = module.postgresql_flexible.postgresql_database_name
    username = module.postgresql_flexible.postgresql_administrator_login
    sslmode  = "require"
  }
}

output "postgresql_server_configuration" {
  description = "PostgreSQL Server configuration details"
  value = {
    version        = var.postgresql_config.version
    sku_name       = var.postgresql_config.sku_name
    tier           = var.postgresql_config.tier
    storage_gb     = var.postgresql_config.storage_mb / 1024
    zone_redundant = var.postgresql_config.zone_redundant
    ha_mode        = var.postgresql_config.high_availability_mode
    backup_days    = var.postgresql_config.backup_retention_days
  }
}

output "postgresql_installed_extensions" {
  description = "List of installed PostgreSQL extensions"
  value       = module.postgresql_flexible.postgresql_installed_extensions
}

output "postgresql_firewall_rules" {
  description = "PostgreSQL firewall rules"
  value       = module.postgresql_flexible.postgresql_firewall_rules
}

# ========== INFRASTRUCTURE SUMMARY ==========
output "infrastructure_summary" {
  description = "Complete infrastructure deployment summary"
  value = {
    resource_group = data.azurerm_resource_group.existing.name
    location       = data.azurerm_resource_group.existing.location

    network = {
      vnet      = module.vnet.vnet_name
      subnets   = keys(var.subnets)
      vnet_cidr = var.vnet_address_space[0]
    }

    compute = {
      public_vms  = var.vm_config.public.vm_count
      private_vms = var.vm_config.private.vm_count
      total_vms   = var.vm_config.public.vm_count + var.vm_config.private.vm_count
    }

    database = {
      engine     = "PostgreSQL"
      version    = var.postgresql_config.version
      server     = module.postgresql_flexible.postgresql_server_name
      database   = module.postgresql_flexible.postgresql_database_name
      tier       = var.postgresql_config.tier
      storage_gb = var.postgresql_config.storage_mb / 1024
      ha_mode    = var.postgresql_config.high_availability_mode
    }

    connectivity = {
      ssh_allowed_from = local.my_public_ip
      #app_port         = var.app_config.app_port
      db_port = 5432
    }
  }
}
*/
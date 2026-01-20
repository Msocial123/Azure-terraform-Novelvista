# ========== RESOURCE GROUP ==========
variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name is required."
  }
}

variable "location" {
  type = string
}

# ========== TAGS ==========
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "AzureInfra"
    ManagedBy   = "Terraform"
  }
}

# ========== NETWORK CONFIGURATION ==========
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "clahan-vnet-main"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["192.169.0.0/16"]
  validation {
    condition     = length(var.vnet_address_space) > 0
    error_message = "At least one address space must be specified."
  }
}

variable "subnets" {
  description = "Subnet configurations"
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = {
    public = {
      name             = "clahan-public"
      address_prefixes = ["192.169.1.0/24"]
    }
    private = {
      name             = "clahan-private"
      address_prefixes = ["192.169.2.0/24"]
    }
    database = {
      name             = "clahan-database"
      address_prefixes = ["192.169.3.0/24"]
    }
  }
}

# ========== SSH CONFIGURATION ==========
variable "ssh_config" {
  description = "SSH key configuration"
  type = object({
    key_name  = string
    algorithm = string
    rsa_bits  = number
  })
  default = {
    key_name  = "azure-ssh-key"
    algorithm = "RSA"
    rsa_bits  = 4096
  }
}


# ========== COMPUTE CONFIGURATION ==========
variable "vm_config" {
  description = "Virtual machine configurations"
  type = object({
    public = object({
      size                 = string
      admin_username       = string
      storage_account_type = string
    })
    private = object({
      size                 = string
      admin_username       = string
      storage_account_type = string
    })
  })
  default = {
    public = {
      size                 = "Standard_B1s"
      admin_username       = "clahanadmin" # Changed from admin
      storage_account_type = "Standard_LRS"
    }
    private = {
      size                 = "Standard_B1s"
      admin_username       = "appuser"
      storage_account_type = "Standard_LRS"
    }
  }
}

variable "subscription_id" {
  type = string
}

variable "resource_provider_registrations" {
  type = string
}
# ========== POSTGRESQL FLEXIBLE SERVER CONFIGURATION ==========
variable "postgresql_config" {
  description = "PostgreSQL Flexible Server configuration"
  type = object({
    # Server Basic Settings
    server_name         = string
    db_name             = string
    administrator_login = string

    # Compute Configuration
    sku_name       = string # Example: "GP_Standard_D2s_v3", "MO_Standard_E2s_v3"
    tier           = string # "Burstable", "GeneralPurpose", "MemoryOptimized"
    storage_mb     = number # Storage in MB (32768 to 16777216)
    zone_redundant = bool

    # Database Settings
    version   = string # "11", "12", "13", "14", "15", "16"
    charset   = string
    collation = string

    # Features
    backup_retention_days = number
    geo_redundant_backup  = bool
    auto_grow_enabled     = bool
    ssl_enforcement       = bool

    # High Availability
    high_availability_mode = optional(string, "Disabled") # "Disabled", "ZoneRedundant", "SameZone"

    # Maintenance Window
    maintenance_window = optional(object({
      day_of_week  = number
      start_hour   = number
      start_minute = number
      }), {
      day_of_week  = 0
      start_hour   = 0
      start_minute = 0
    })

    # Database Extensions
    db_extensions = optional(list(string), [
      "uuid-ossp",
      "pgcrypto",
      "postgis",
      "pg_stat_statements"
    ])
  })

  default = {
    # Server Identification
    server_name         = "postgresql-flex-server"
    db_name             = "appdb"
    administrator_login = "psqladmin"

    # Compute Configuration
    sku_name       = "GP_Standard_D2s_v3"
    tier           = "GeneralPurpose"
    storage_mb     = 32768 # 32GB
    zone_redundant = false

    # Database Settings
    version   = "15"
    charset   = "UTF8"
    collation = "en_US.utf8"

    # Features
    backup_retention_days = 7
    geo_redundant_backup  = false
    auto_grow_enabled     = true
    ssl_enforcement       = true

    # High Availability
    high_availability_mode = "Disabled"

    # Maintenance Window (Sunday 2 AM UTC)
    maintenance_window = {
      day_of_week  = 0
      start_hour   = 2
      start_minute = 0
    }

    # Database Extensions
    db_extensions = [
      "uuid-ossp",
      "pgcrypto",
      "pg_stat_statements"
    ]
  }


  # Validations
  validation {
    condition     = contains(["11", "12", "13", "14", "15", "16"], var.postgresql_config.version)
    error_message = "PostgreSQL version must be one of: 11, 12, 13, 14, 15, 16."
  }

  validation {
    condition     = contains(["Burstable", "GeneralPurpose", "MemoryOptimized"], var.postgresql_config.tier)
    error_message = "Tier must be one of: Burstable, GeneralPurpose, MemoryOptimized."
  }

  validation {
    condition     = var.postgresql_config.storage_mb >= 32768 && var.postgresql_config.storage_mb <= 16777216
    error_message = "Storage must be between 32768MB (32GB) and 16777216MB (16TB)."
  }

  validation {
    condition     = var.postgresql_config.backup_retention_days >= 7 && var.postgresql_config.backup_retention_days <= 35
    error_message = "Backup retention days must be between 7 and 35."
  }

  validation {
    condition     = contains(["Disabled", "ZoneRedundant", "SameZone"], var.postgresql_config.high_availability_mode)
    error_message = "High availability mode must be one of: Disabled, ZoneRedundant, SameZone."
  }
}

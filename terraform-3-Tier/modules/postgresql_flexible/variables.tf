variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

# Network configuration (OPTIONAL for public access)
variable "network_config" {
  description = "Network configuration - optional for public access"
  type = object({
    vnet_id     = string
    subnet_id   = string
    subnet_cidr = string
  })
  default = null # Make it optional
}

variable "postgresql_config" {
  description = "PostgreSQL Flexible Server configuration"
  type = object({
    # Server Basic Settings
    server_name         = string
    db_name             = string
    administrator_login = string

    # Compute Configuration
    sku_name   = string
    storage_mb = number

    # Database Settings
    version = string

    # Features
    backup_retention_days = number
    geo_redundant_backup  = bool
    auto_grow_enabled     = bool
    ssl_enforcement       = bool

    # Optional
    high_availability_mode = optional(string, "Disabled")
    zone_redundant         = optional(bool, false)
    charset                = optional(string, "UTF8")
    collation              = optional(string, "en_US.utf8")
    maintenance_window = optional(object({
      day_of_week  = optional(number, 0)
      start_hour   = optional(number, 0)
      start_minute = optional(number, 0)
    }), {})
  })
}

variable "allowed_app_subnet_cidr" {
  description = "CIDR block of the app subnet allowed to access database"
  type        = string
}

variable "allowed_public_subnet_cidr" {
  description = "CIDR block of the public subnet allowed to access database"
  type        = string
  default     = null
}

variable "allow_all_ips" {
  description = "Allow connections from all IPs (for learning/testing)"
  type        = bool
  default     = false # Set to true for learning
}

variable "db_extensions" {
  description = "List of PostgreSQL extensions to install"
  type        = list(string)
  default     = []
}
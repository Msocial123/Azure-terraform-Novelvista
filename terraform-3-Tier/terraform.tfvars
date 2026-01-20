# ========== BASIC CONFIGURATION ==========
# Azure Configuration
subscription_id                 = "102e26df-c1b9-4282-bc2e-9da3bd2164b4"
resource_group_name             = "azureskf-T"
resource_provider_registrations = "none"
location                        = "francecentral"


# ========== TAGS ==========
tags = {
  Environment        = "Production"
  Project            = "ECommercePlatform"
  Team               = "Platform-Engineering"
  CostCenter         = "IT-456"
  Owner              = "platform@company.com"
  DataClassification = "PII"
}

# ========== NETWORK CONFIGURATION ==========
vnet_name          = "CLahan-3-Tier-Vnet"
vnet_address_space = ["192.169.0.0/16"]

subnets = {
  public = {
    name             = "clahan-public-lb"
    address_prefixes = ["192.169.10.0/24"]
  }
  private = {
    name             = "clahan-private-app"
    address_prefixes = ["192.169.20.0/24"]
  }
  database = {
    name             = "clahan-database-pg"
    address_prefixes = ["192.169.30.0/24"]
  }
}

# ========== SSH CONFIGURATION ==========
ssh_config = {
  key_name  = "clahan-3-tier-key"
  algorithm = "RSA"
  rsa_bits  = 4096
}

# ========== COMPUTE CONFIGURATION ==========
vm_config = {
  public = {
    size                 = "Standard_B2s"
    admin_username       = "clahan"
    storage_account_type = "Premium_LRS"
    caching_type         = "ReadWrite"
    vm_count             = 2 # Load balancer frontend
  }
  private = {
    size                 = "Standard_D4s_v3" # Better for application servers
    admin_username       = "clahanappuser"
    storage_account_type = "Premium_LRS"
    caching_type         = "ReadWrite"
    vm_count             = 4 # Application servers
  }
}

app_config = {
  app_port    = 8080
  admin_ports = [22, 443, 9100] # SSH, HTTPS, Node Exporter
}

# ========== POSTGRESQL FLEXIBLE SERVER CONFIGURATION ==========
postgresql_config = {
  # Server Identification
  server_name         = "pg-flex-prod-01"
  db_name             = "clahanecommerce_db"
  administrator_login = "clahanpgadmin"

  # Compute Configuration - Production Grade
  sku_name       = "GP_Standard_D4s_v3" # General Purpose, 4 vCPUs, 16GB RAM
  tier           = "GeneralPurpose"
  storage_mb     = 131072 # 128GB storage
  zone_redundant = true   # Enable Zone Redundant High Availability

  # Database Settings - Using latest stable version
  version   = "16"
  charset   = "UTF8"
  collation = "en_US.utf8"

  # Backup & Security
  backup_retention_days = 21   # 3 weeks retention
  geo_redundant_backup  = true # Geo-redundant backup for DR
  auto_grow_enabled     = true # Auto-grow storage when needed
  ssl_enforcement       = true # Enforce SSL connections

  # High Availability - Zone Redundant
  high_availability_mode = "ZoneRedundant"

  # Maintenance Window - Sunday 1:00 AM UTC
  maintenance_window = {
    day_of_week  = 0 # Sunday
    start_hour   = 1
    start_minute = 0
  }

  # Database Extensions for modern applications
  db_extensions = [
    "uuid-ossp",          # UUID generation
    "pgcrypto",           # Cryptographic functions
    "pg_stat_statements", # Query performance monitoring
    "pg_partman",         # Table partitioning
    "timescaledb",        # Time-series data (if needed)
    "postgis",            # Geospatial data support
    "pg_repack",          # Table bloat management
    "pgaudit"             # Auditing
  ]
}
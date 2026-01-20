# Generate random password for PostgreSQL
resource "random_password" "postgresql_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# PostgreSQL Flexible Server with PUBLIC ACCESS
resource "azurerm_postgresql_flexible_server" "postgresql_server" {
  name                = var.postgresql_config.server_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Authentication
  administrator_login    = var.postgresql_config.administrator_login
  administrator_password = random_password.postgresql_password.result

  # Compute and Storage
  sku_name   = var.postgresql_config.sku_name
  storage_mb = var.postgresql_config.storage_mb

  # Version
  version = var.postgresql_config.version

  # Backup
  backup_retention_days        = var.postgresql_config.backup_retention_days
  geo_redundant_backup_enabled = var.postgresql_config.geo_redundant_backup

  # ========== FIX: PUBLIC NETWORK ACCESS ==========
  public_network_access_enabled = true

  # ========== REMOVE/COMMENT THESE FOR PUBLIC ACCESS ==========
  # delegated_subnet_id = var.network_config.subnet_id  # REMOVE THIS
  # private_dns_zone_id = azurerm_private_dns_zone.postgresql_dns.id  # REMOVE THIS

  # High Availability (only if enabled)
  dynamic "high_availability" {
    for_each = var.postgresql_config.high_availability_mode != "Disabled" ? [1] : []

    content {
      mode                      = var.postgresql_config.high_availability_mode
      standby_availability_zone = var.postgresql_config.zone_redundant ? "2" : "1"
    }
  }

  # Maintenance Window
  dynamic "maintenance_window" {
    for_each = var.postgresql_config.maintenance_window.day_of_week >= 0 ? [1] : []

    content {
      day_of_week  = var.postgresql_config.maintenance_window.day_of_week
      start_hour   = var.postgresql_config.maintenance_window.start_hour
      start_minute = var.postgresql_config.maintenance_window.start_minute
    }
  }
  /*
  # Storage Configuration (REQUIRED - uncomment this)
  storage {
    auto_grow_enabled = var.postgresql_config.auto_grow_enabled
    # iops is auto-calculated, don't specify it
  }

  # SSL Enforcement (REQUIRED - uncomment this)
  ssl_enforcement_enabled          = var.postgresql_config.ssl_enforcement
  ssl_minimal_tls_version_enforced = "TLS1_2"
*/
  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone
    ]
  }
}

# PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "postgresql_database" {
  name      = var.postgresql_config.db_name
  server_id = azurerm_postgresql_flexible_server.postgresql_server.id
  charset   = var.postgresql_config.charset
  collation = var.postgresql_config.collation
}

# ========== FIREWALL RULES FOR PUBLIC ACCESS ==========

# Allow Azure services (0.0.0.0 means Azure internal)
resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.postgresql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Allow specific IPs or ranges
resource "azurerm_postgresql_flexible_server_firewall_rule" "app_subnet" {
  name             = "allow-app-subnet"
  server_id        = azurerm_postgresql_flexible_server.postgresql_server.id
  start_ip_address = cidrhost(var.allowed_app_subnet_cidr, 0)
  end_ip_address   = cidrhost(var.allowed_app_subnet_cidr, 255)
}

# Optional: Allow all IPs for learning (CAREFUL in production!)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  count = var.allow_all_ips ? 1 : 0

  name             = "allow-all-ips"
  server_id        = azurerm_postgresql_flexible_server.postgresql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

# ========== REMOVE PRIVATE DNS ZONE - NOT NEEDED FOR PUBLIC ACCESS ==========
# Comment out or delete these resources:
# resource "azurerm_private_dns_zone" "postgresql_dns" {
#   name                = "${var.postgresql_config.server_name}.private.postgres.database.azure.com"
#   resource_group_name = var.resource_group_name
#   tags                = var.tags
# }
# 
# resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_dns_link" {
#   name                  = "postgresql-dns-link"
#   private_dns_zone_name = azurerm_private_dns_zone.postgresql_dns.name
#   virtual_network_id    = var.network_config.vnet_id
#   resource_group_name   = var.resource_group_name
#   tags                  = var.tags
# }

# Install PostgreSQL Extensions (OPTIONAL)
resource "azurerm_postgresql_flexible_server_configuration" "extensions" {
  for_each = { for idx, ext in var.db_extensions : idx => ext }

  name      = "shared_preload_libraries"
  server_id = azurerm_postgresql_flexible_server.postgresql_server.id
  value     = each.value
}

# PostgreSQL Server Configuration for Performance (OPTIONAL)
resource "azurerm_postgresql_flexible_server_configuration" "performance_tuning" {
  for_each = {
    "max_connections"              = "100"
    "shared_buffers"               = "128MB"
    "effective_cache_size"         = "1024MB"
    "maintenance_work_mem"         = "64MB"
    "checkpoint_completion_target" = "0.9"
    "wal_buffers"                  = "16MB"
    "default_statistics_target"    = "100"
    "random_page_cost"             = "1.1"
    "effective_io_concurrency"     = "200"
    "work_mem"                     = "4MB"
    "min_wal_size"                 = "1GB"
    "max_wal_size"                 = "4GB"
    "log_min_duration_statement"   = "1000"
  }

  name      = each.key
  server_id = azurerm_postgresql_flexible_server.postgresql_server.id
  value     = each.value
}
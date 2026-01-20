locals {
  #my_public_ip = "${chomp(data.http.my_ip.response_body)}/32"

  # Subnet CIDRs for reference
  database_subnet_cidr = var.subnets["database"].address_prefixes[0]
  private_subnet_cidr  = var.subnets["private"].address_prefixes[0]
  public_subnet_cidr   = var.subnets["public"].address_prefixes[0]

  # PostgreSQL Flexible Server configuration
  postgresql_config = {
    server_name         = var.postgresql_config.server_name
    db_name             = var.postgresql_config.db_name
    administrator_login = var.postgresql_config.administrator_login

    # Compute
    sku_name       = var.postgresql_config.sku_name
    tier           = var.postgresql_config.tier
    storage_mb     = var.postgresql_config.storage_mb
    zone_redundant = var.postgresql_config.zone_redundant

    # Database
    version   = var.postgresql_config.version
    charset   = var.postgresql_config.charset
    collation = var.postgresql_config.collation

    # Features
    backup_retention_days = var.postgresql_config.backup_retention_days
    geo_redundant_backup  = var.postgresql_config.geo_redundant_backup
    auto_grow_enabled     = var.postgresql_config.auto_grow_enabled
    ssl_enforcement       = var.postgresql_config.ssl_enforcement

    # Optional
    high_availability_mode = var.postgresql_config.high_availability_mode
    maintenance_window     = var.postgresql_config.maintenance_window
  }
}
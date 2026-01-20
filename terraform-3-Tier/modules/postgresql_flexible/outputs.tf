output "postgresql_server_id" {
  description = "PostgreSQL Flexible Server resource ID"
  value       = azurerm_postgresql_flexible_server.postgresql_server.id
}

output "postgresql_server_name" {
  description = "PostgreSQL Flexible Server name"
  value       = azurerm_postgresql_flexible_server.postgresql_server.name
}

output "postgresql_server_fqdn" {
  description = "PostgreSQL Flexible Server fully qualified domain name"
  value       = azurerm_postgresql_flexible_server.postgresql_server.fqdn
}

output "postgresql_database_name" {
  description = "PostgreSQL database name"
  value       = azurerm_postgresql_flexible_server_database.postgresql_database.name
}

output "postgresql_administrator_login" {
  description = "PostgreSQL administrator login"
  value       = var.postgresql_config.administrator_login
}

output "postgresql_administrator_password" {
  description = "PostgreSQL administrator password (sensitive)"
  value       = random_password.postgresql_password.result
  sensitive   = true
}

output "postgresql_connection_strings" {
  description = "PostgreSQL connection strings"
  value = {
    psql    = "psql \"host=${azurerm_postgresql_flexible_server.postgresql_server.fqdn} dbname=${azurerm_postgresql_flexible_server_database.postgresql_database.name} user=${var.postgresql_config.administrator_login} sslmode=require\""
    jdbc    = "jdbc:postgresql://${azurerm_postgresql_flexible_server.postgresql_server.fqdn}:5432/${azurerm_postgresql_flexible_server_database.postgresql_database.name}?user=${var.postgresql_config.administrator_login}&sslmode=require"
    nodejs  = "postgresql://${var.postgresql_config.administrator_login}@${azurerm_postgresql_flexible_server.postgresql_server.fqdn}:5432/${azurerm_postgresql_flexible_server_database.postgresql_database.name}?sslmode=require"
    generic = "postgresql://${var.postgresql_config.administrator_login}@${azurerm_postgresql_flexible_server.postgresql_server.fqdn}:5432/${azurerm_postgresql_flexible_server_database.postgresql_database.name}"
  }
  sensitive = true
}

output "postgresql_server_endpoint" {
  description = "PostgreSQL Server endpoint details"
  value = {
    host     = azurerm_postgresql_flexible_server.postgresql_server.fqdn
    port     = 5432
    database = azurerm_postgresql_flexible_server_database.postgresql_database.name
    username = var.postgresql_config.administrator_login
    sslmode  = "require"
  }
}
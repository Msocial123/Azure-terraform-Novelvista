variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "server_name" {
  description = "PostgreSQL server name"
  type        = string
}

variable "administrator_login" {
  description = "PostgreSQL administrator login"
  type        = string
}

variable "administrator_password" {
  description = "PostgreSQL administrator password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "sku_name" {
  description = "PostgreSQL SKU name"
  type        = string
}

variable "storage_mb" {
  description = "Storage size in MB"
  type        = number
}
/*
variable "version" {
  description = "PostgreSQL version"
  type        = string
  default     = "13"
}
*/

variable "db_subnet_id" {
  description = "Database subnet ID"
  type        = string
}

variable "vnet_id" {
  description = "Virtual network ID"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
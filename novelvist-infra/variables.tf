# Global Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "novelvista-rg"
}
variable "subscription_id" {
  type = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "company_name" {
  type        = string
  description = "Company or organization name"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "suffix" {
  type        = string
  description = "Unique suffix for naming"
}

variable "project_name" {
  description = "Project name for naming conventions"
  type        = string
  default     = "novelvista"
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default = {
    Project     = "NovelVista"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# VNet Module Variables
variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

# Subnets Configuration
variable "subnets" {
  description = "Configuration for all subnets"
  type = map(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = optional(list(string))
  }))
}


# AKS Module Variables

variable "enable_auto_scaling" {
  type        = bool
  description = "Enable autoscaling for system node pool"
}

variable "enable_node_public_ip" {
  type = bool
}

variable "node_taints" {
  type = list(string)
}


variable "aks_config" {
  description = "AKS cluster configuration"
  type = object({
    cluster_name            = string
    dns_prefix              = string
    kubernetes_version      = string
    private_cluster_enabled = bool

    system_node_pool = object({
      name                = string
      node_count          = number
      vm_size             = string
      os_disk_size_gb     = number
      type                = string
      enable_auto_scaling = bool
    })

    user_node_pools = list(object({
      name                = string
      node_count          = number
      vm_size             = string
      os_disk_size_gb     = number
      os_type             = string
      os_sku              = string
      enable_auto_scaling = bool
    }))
  })
}

# Database Module Variables
variable "database_config" {
  description = "PostgreSQL Flexible Server configuration"
  type = object({
    server_name            = string
    administrator_login    = string
    administrator_password = string
    database_name          = string
    sku_name               = string
    storage_mb             = number
    version                = string
  })
}

# VM Module Variables
variable "vm_config" {
  description = "Virtual Machine configuration"
  type = object({
    vm_name           = string
    vm_size           = string
    admin_username    = string
    public_ip_enabled = bool
    custom_data_file  = string
    os_image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    os_disk = object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = number
    })
  })
}

# SSH Module Variables
variable "ssh_config" {
  description = "SSH key configuration"
  type = object({
    algorithm = string
    rsa_bits  = number
    key_name  = string
  })
  default = {
    algorithm = "RSA"
    rsa_bits  = 4096
    key_name  = "novelvista-vm-key"
  }
}

variable "resource_provider_registrations" {
  type = string
}
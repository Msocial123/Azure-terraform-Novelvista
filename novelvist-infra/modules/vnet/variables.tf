variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "company_name" {
  type        = string
  description = "Company/project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "VNet address space"
}

variable "vnet_name" {
  type = string
}



variable "suffix" {
  type        = string
  description = "Random suffix for unique naming"
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
}
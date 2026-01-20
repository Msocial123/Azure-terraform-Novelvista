variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_id" {
  description = "Virtual Network ID"
  type        = string
}

variable "subnets" {
  description = "Subnet configurations"
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
variable "vnet_id" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnets" {
  type = map(any)
}

variable "vnet_name" {
  type = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
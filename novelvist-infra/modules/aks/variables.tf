variable "company_name" { type = string }
variable "environment" { type = string }
variable "suffix" { type = string }

variable "resource_group_name" { type = string }
variable "location" { type = string }

variable "cluster_name" { type = string }
variable "dns_prefix" { type = string }
variable "kubernetes_version" { type = string }

variable "aks_subnet_id" {
  type = string
}

variable "private_cluster_enabled" {
  type = bool
}

variable "enable_auto_scaling" {
  type = bool
}

variable "enable_node_public_ip" {
  type = bool
}

variable "node_taints" {
  type    = list(string)
  default = []
}

variable "system_node_pool" {
  type = object({
    name            = string
    node_count      = number
    vm_size         = string
    os_disk_size_gb = number
    type            = string
  })
}

variable "user_node_pools" {
  type = list(object({
    name                = string
    node_count          = number
    vm_size             = string
    os_disk_size_gb     = number
    os_type             = string
    os_sku              = string
    enable_auto_scaling = bool
  }))
  default = []
}

variable "ssh_public_key" {
  type = string
}

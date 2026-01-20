variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = string
}

# Public VM variables
variable "public_vm_name" {
  description = "Public VM name"
  type        = string
  default     = "vm-public-01"
}

variable "public_vm_size" {
  description = "Public VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "public_vm_username" {
  description = "Public VM admin username"
  type        = string
  default     = "student"
}

variable "public_vm_disk_type" {
  description = "Public VM disk type"
  type        = string
  default     = "Standard_LRS"
}

# Private VM variables
variable "private_vm_name" {
  description = "Private VM name"
  type        = string
  default     = "vm-private-01"
}

variable "private_vm_size" {
  description = "Private VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "private_vm_username" {
  description = "Private VM admin username"
  type        = string
  default     = "appuser"
}

variable "private_vm_disk_type" {
  description = "Private VM disk type"
  type        = string
  default     = "Standard_LRS"
}
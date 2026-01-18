variable "algorithm" {
  description = "Algorithm for SSH key"
  type        = string
  default     = "RSA"
}

variable "rsa_bits" {
  description = "RSA bits for SSH key"
  type        = number
  default     = 4096
}

variable "key_name" {
  description = "Name of the SSH key file"
  type        = string
  default     = "novelvista-aks-key"
}
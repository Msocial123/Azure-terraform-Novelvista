output "public_vm_public_ip" {
  description = "Public IP address of the public VM"
  value       = azurerm_public_ip.public_vm_ip.ip_address
}

output "public_vm_private_ip" {
  description = "Private IP address of the public VM"
  value       = azurerm_network_interface.public_nic.private_ip_address
}

output "private_vm_private_ip" {
  description = "Private IP address of the private VM"
  value       = azurerm_network_interface.private_nic.private_ip_address
}

output "ssh_command" {
  description = "SSH command to connect to public VM"
  value       = "ssh ${var.public_vm_username}@${azurerm_public_ip.public_vm_ip.ip_address}"
}
/*
output "vm_id" {
  description = "Virtual machine ID"
  value       = azurerm_linux_virtual_machine.main.id
}

output "public_ip_address" {
  description = "Public IP address"
  value       = var.public_ip_enabled ? azurerm_public_ip.vm[0].ip_address : null
}

output "private_ip_address" {
  description = "Private IP address"
  value       = azurerm_network_interface.vm.private_ip_address
}

output "network_interface_id" {
  description = "Network Interface ID"
  value       = azurerm_network_interface.vm.id
}

output "nsg_id" {
  description = "Network Security Group ID"
  value       = azurerm_network_security_group.vm.id
}

output "public_ip_id" {
  description = "Public IP resource ID"
  value       = var.public_ip_enabled ? azurerm_public_ip.vm[0].id : null
}
*/
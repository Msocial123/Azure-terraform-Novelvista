output "subnet_ids" {
  description = "Subnet IDs"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_names" {
  description = "Subnet names"
  value       = { for k, v in azurerm_subnet.subnets : k => v.name }
}
/*
output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "Virtual Network ID"
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = module.vnet.vnet_name
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value       = module.subnets.subnet_ids
}

output "subnet_names" {
  description = "Map of subnet names"
  value       = module.subnets.subnet_names
}

output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.cluster_name
}

output "aks_cluster_fqdn" {
  description = "AKS cluster FQDN"
  value       = module.aks.cluster_fqdn
}

output "aks_kube_config" {
  description = "Kubeconfig for AKS cluster"
  value       = module.aks.kube_config
  sensitive   = true
}

output "postgresql_server_fqdn" {
  description = "PostgreSQL server FQDN"
  value       = module.database.server_fqdn
}

output "postgresql_database_name" {
  description = "PostgreSQL database name"
  value       = module.database.database_name
}

output "vm_public_ip" {
  description = "VM public IP address"
  value       = module.vm.public_ip_address
}

output "vm_private_ip" {
  description = "VM private IP address"
  value       = module.vm.private_ip_address
}

output "vm_ssh_command" {
  description = "SSH command to connect to VM"
  value       = "ssh -i keys/${var.ssh_config.key_name} ${var.vm_config.admin_username}@${module.vm.public_ip_address}"
}

output "ssh_private_key_path" {
  description = "Path to generated SSH private key"
  value       = module.ssh_key.private_key_path
}

output "ssh_public_key_path" {
  description = "Path to generated SSH public key"
  value       = module.ssh_key.public_key_path
}

output "ssh_public_key_content" {
  description = "SSH public key content"
  value       = module.ssh_key.public_key_openssh
  sensitive   = true
}

output "database_connection_string" {
  description = "PostgreSQL connection string"
  value       = "postgresql://${module.database.administrator_login}:${module.database.administrator_password}@${module.database.server_fqdn}/${module.database.database_name}"
  sensitive   = true
}

output "vm_nic_id" {
  description = "VM Network Interface ID"
  value       = module.vm.network_interface_id
}

output "vm_id" {
  description = "Virtual Machine ID"
  value       = module.vm.vm_id
}
*/
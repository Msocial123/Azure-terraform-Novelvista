# ========== PUBLIC VM ==========
resource "azurerm_public_ip" "public_vm_ip" {
  name                = "pip-vm-public"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Basic"
  tags                = var.tags
}

resource "azurerm_network_interface" "public_nic" {
  name                = "nic-vm-public"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.public_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_vm_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "public_vm" {
  name                  = var.public_vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.public_vm_size
  admin_username        = var.public_vm_username
  network_interface_ids = [azurerm_network_interface.public_nic.id]
  tags                  = var.tags

  admin_ssh_key {
    username   = var.public_vm_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.public_vm_disk_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# ========== PRIVATE VM ==========
resource "azurerm_network_interface" "private_nic" {
  name                = "nic-vm-private"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.private_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "private_vm" {
  name                  = var.private_vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.private_vm_size
  admin_username        = var.private_vm_username
  network_interface_ids = [azurerm_network_interface.private_nic.id]
  tags                  = var.tags

  admin_ssh_key {
    username   = var.private_vm_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.private_vm_disk_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# ========== SIMPLE NSG ==========
resource "azurerm_network_security_group" "public_nsg" {
  name                = "nsg-public"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-All-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = var.public_subnet_id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}
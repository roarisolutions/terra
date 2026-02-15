terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Use the count variable to create multiple resource groups
resource "azurerm_resource_group" "rg" {
  count    = var.vm_count
  name     = "${var.resource_group_name_prefix}-${count.index + 1}"
  location = var.location
}

# Create multiple public IPs
resource "azurerm_public_ip" "public_ip" {
  count               = var.vm_count
  name                = "${var.vm_name_prefix}-pubip-${count.index + 1}"
  location            = azurerm_resource_group.rg[count.index].location
  resource_group_name = azurerm_resource_group.rg[count.index].name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create multiple network interfaces
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.vm_name_prefix}-nic-${count.index + 1}"
  location            = azurerm_resource_group.rg[count.index].location
  resource_group_name = azurerm_resource_group.rg[count.index].name

  ip_configuration {
    name                 = "internal"
    subnet_id            = var.subnet_id # You must provide a valid subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip[count.index].id
  }
}

# Create multiple Linux VMs
resource "azurerm_linux_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "${var.vm_name_prefix}-${count.index + 1}"
  location              = azurerm_resource_group.rg[count.index].location
  resource_group_name   = azurerm_resource_group.rg[count.index].name
  size                  = "Standard_DS1_v2"
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  admin_ssh_key {
    username = var.admin_username
    key_data = file("~/.ssh/id_rsa.pub") # Assumes you have an SSH public key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# Output the public IP addresses of the created VMs
output "public_ips" {
  value = azurerm_public_ip.public_ip[*].ip_address
}

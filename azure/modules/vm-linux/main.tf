resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}

########################################
# PUBLIC IP
########################################
resource "azurerm_public_ip" "pip" {
  for_each = var.vms

  name                = "${each.key}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

########################################
# NIC
########################################
resource "azurerm_network_interface" "nic" {
  for_each = var.vms

  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_ids[each.value.subnet_name]
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

########################################
# LINUX VM (UBUNTU)
########################################
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.vms

  name = "tf-${terraform.workspace}-${each.key}-${local.suffix}"

  location            = var.location
  resource_group_name = var.resource_group_name
  size                = each.value.size

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false   # keep simple

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = var.tags
}
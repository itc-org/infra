locals {
  suffix = random_string.suffix.result
}


resource "azurerm_subnet" "vm_subnet" {
  name                 = "vm-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_prefix
}

resource "azurerm_public_ip" "pip" {
  for_each = var.vm_enabled ? var.vms : {}

  name                = "${each.key}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  for_each = var.vm_enabled ? var.vms : {}

  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.vm_enabled ? var.vms : {}

  name                = "tf-${terraform.workspace}-${each.key}-${local.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = each.value.size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

source_image_reference {
  publisher = "MicrosoftWindowsDesktop"
  offer     = "windows-11"
  sku       = "win11-24h2-pro"
  version   = "latest"
}

  tags = var.tags
}
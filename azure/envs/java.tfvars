
vnet_address_space = [
  "10.0.0.0/16"  
]

# Enable VM
vm_enabled = true

# VMs count
vms = {
  vm1 = {
    size            = "Standard_B2s"
    subnet_prefix   = ["10.0.1.0/24"]
  }
}

vm_admin_username = "azureuser"
vm_admin_password = "Password123!"


# Key Vault
keyvault_enabled = false

keyvaults = {
  kv1 = {}
}


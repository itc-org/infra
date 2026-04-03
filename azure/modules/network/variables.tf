variable "vnet_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "vnet_address_space" {}

variable "vms" {
  type = map(object({
    size          = string
    subnet_prefix = list(string)
  }))
}

variable "tags" {}
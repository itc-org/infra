variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "vnet_name" { type = string }


variable "admin_username" { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}


variable "vm_enabled" {
  type = bool
}

variable "vms" {
  type = map(object({
    size          = string
    subnet_prefix = list(string)
  }))
}

variable "subnet_ids" {
  type = map(string)
}
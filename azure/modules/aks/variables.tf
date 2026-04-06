variable "aks" {
  type = object({
    node_count  = number
    vm_size     = string
    subnet_name = string
  })
}

variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}

  variable "tags" {
  type    = map(string)
  default = {}
}


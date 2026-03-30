variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "standard"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "managed_resource_group_name" {}

variable "databricks_public_network_access_enabled" {}
variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "filesystem_id" {}

variable "resource_group_name" {
  type = string
}

variable "sql_admin_login" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

# variable "aad_admin_login" {}
# variable "aad_admin_object_id" {}
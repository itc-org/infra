variable "synapse" {
  type = map(any)
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sql_admin_username" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "filesystem_ids" {
  type = map(string)
}

  variable "tags" {
  type    = map(string)
  default = {}
}


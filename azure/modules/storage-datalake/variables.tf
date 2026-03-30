variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "filesystem_name" {}
variable "datalake_tier" {}
variable "datlake_redundancy" {}


variable "tags" {
  type    = map(string)
  default = {}
}
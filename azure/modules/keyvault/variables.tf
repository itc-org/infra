variable "keyvault" {
  type = object({
    sku_name                    = string
    enabled_for_disk_encryption = bool
  })
}



variable "location" {}
variable "resource_group_name" {}
variable "tenant_id" {}

variable "tags" {
  type    = map(string)
  default = {}
}
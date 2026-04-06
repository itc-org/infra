variable "databricks" {
  type = map(object({
    sku = string
  }))
}

variable "location" {}
variable "resource_group_name" {}
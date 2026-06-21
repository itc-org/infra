# variable "vpc_id" {
#   type = string
# }

# variable "subnet_ids" {
#   type = list(string)
# }

# variable "container_image" {
#   type = string
# }

# variable "container_port" {
#   type = number
#   default = 80
# }

variable "ecs_name" {
}

variable "container_insights" {
  type    = bool
  default = false # off keeps it cheap; enable for metrics (adds CloudWatch cost)
}

variable "enable_fargate_spot" {
  type    = bool
  default = true # Fargate Spot = cheapest compute, ideal for dev/test
}
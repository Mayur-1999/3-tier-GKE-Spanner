variable "project_id" {
  description = "The ID of the project where subnets will be created"
  type        = string
}

variable "vpc_info" {
  type = object({
    name                            = string
    auto_create_subnetworks         = bool
    routing_mode                    = string
    description                     = string
    delete_default_routes_on_create = bool
    mtu                             = number
  })
}

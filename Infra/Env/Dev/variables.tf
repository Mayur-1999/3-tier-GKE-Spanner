variable "region" {
  type = string
}

variable "project_id" {
}

variable "service_account" {
  type = string
}

# variable "vpc_info" {
#   type = object({
#     name                    = string
#     auto_create_subnetworks = bool
#     routing_mode            = bool
#   })
#   default = {
#     name                    = "vpc"
#     auto_create_subnetworks = false
#     routing_mode            = false
#   }
# }

variable "firewall_info" {
  type = object({
    name          = string
    description   = string
    direction     = string
    priority      = string
    source_ranges = list(string)
  })
  default = {
    name          = "app-firewall"
    description   = "firewall to access the application"
    direction     = "INGRESS"
    priority      = "1000"
    source_ranges = ["0.0.0.0/0"]
  }
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
  default = {
    name                            = "vpc"
    auto_create_subnetworks         = false
    routing_mode                    = "GLOBAL"
    description                     = "network for the project"
    delete_default_routes_on_create = false
    mtu                             = 0
  }
}

variable "subnet_info" {
  type = object({
    name                     = string
    ip_cidr_range            = string
    private_ip_google_access = bool
  })
  default = {
    name                     = "subnet"
    ip_cidr_range            = "10.10.0.0/24"
    private_ip_google_access = true
  }
}



variable "region" {
  type = string
}

variable "project_id" {
}

variable "service_account" {
  type = string
}


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

variable "ssh_firewall_info" {
  type = object({
    name          = string
    description   = string
    direction     = string
    priority      = string
    source_ranges = list(string)
  })
  default = {
    name          = "ssh-firewall"
    description   = "firewall to ssh into vm"
    direction     = "INGRESS"
    priority      = "1001"
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
    ip_cidr_range            = "10.0.0.0/24"
    private_ip_google_access = true
  }
}


variable "cluster_info" {
  type = object({
    name                     = string
    location                 = string
    remove_default_node_pool = bool
    initial_node_count       = number
    release_channel          = string
  })
  default = {
    name                     = "onlinebotique-cluster"
    location                 = "us-central1-a"
    remove_default_node_pool = true
    initial_node_count       = 1
    release_channel          = "STABLE"
  }
}

variable "cluster_info" {
  type = object({
    name                     = string
    remove_default_node_pool = bool
    initial_node_count       = number
    release_channel          = string
  })
}

variable "project_id" {
  type = string
}

variable "zone" {}

variable "private_cluster_config" {
  default     = []
  description = "private cluster config"
  type = list(object({
    enable_private_endpoint = bool
    enable_private_nodes    = bool
    master_ipv4_cidr_block  = string
  }))
}

variable "ip_allocation_policy" {
  default     = []
  description = "private cluster config"
  type = list(object({
    cluster_ipv4_cidr_block  = string
    services_ipv4_cidr_block = string
  }))
}

variable "node_pools" {
  type = map(object({
    name               = string
    machine_type       = string
    preemptible        = optional(bool)
    disk_size_gb       = number
    initial_node_count = number
    min_node_count     = number
    max_node_count     = number
    labels             = map(string)
    locations          = list(string)
    taint = list(object({
      key    = string
      value  = string
      effect = string
    }))
    image_type = optional(string)
  }))
  description = "Map of node pool configurations."
}

variable "node_version" {
  type        = string
  description = "The version of Kubernetes to use for the node pools. If not set, it defaults to the cluster's version."
  default     = null
}

variable "enable_windows_nodes" {
  type        = bool
  description = "Enable Windows nodes support"
  default     = false
}

variable "network" {}
variable "subnetwork" {}
variable "service_account" {}

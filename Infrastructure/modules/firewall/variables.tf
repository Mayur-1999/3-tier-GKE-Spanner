# Required Variables
variable "network" {
  type        = string
  description = "The name or self link of the VPC network created in the parent module or environment. (Example: google_compute_network.vpc_network.self_link)"
}

variable "project_id" {
  type        = string
  description = "The GCP project ID (may be a alphanumeric slug) that the resources are deployed in. (Example: my-project-name)"
}

variable "firewall_info" {
  type = object({
    name          = string
    description   = string
    direction     = string
    priority      = string
    source_ranges = list(string)
  })
}

variable "allow" {
  default     = []
  description = "Firewall protocol(s) and port(s) to allow"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
}

variable "deny" {
  default     = []
  description = "Firewall protocol(s) and port(s) to deny"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
}


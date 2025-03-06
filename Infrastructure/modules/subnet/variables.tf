variable "project_id" {
  description = "The ID of the project where subnets will be created"
  type        = string
}

variable "network" {
  description = "The name of the network where subnets will be created"
}

variable "region" {

}

variable "subnet_info" {
  type = object({
    name                     = string
    ip_cidr_range            = string
    private_ip_google_access = string
  })
}

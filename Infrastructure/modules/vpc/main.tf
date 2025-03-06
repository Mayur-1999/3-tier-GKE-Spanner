###############################################################################
# VPC Module
###############################################################################

#VPC configuration
resource "google_compute_network" "network" {
  name                            = var.vpc_info.name
  auto_create_subnetworks         = var.vpc_info.auto_create_subnetworks
  routing_mode                    = var.vpc_info.routing_mode
  project                         = var.project_id
  description                     = var.vpc_info.description
  delete_default_routes_on_create = var.vpc_info.delete_default_routes_on_create
  mtu                             = var.vpc_info.mtu
}









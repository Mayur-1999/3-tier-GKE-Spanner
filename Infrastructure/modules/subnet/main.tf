###############################################################################
# Subnet Module
###############################################################################
resource "google_compute_subnetwork" "subnetwork" {
  name                     = var.subnet_info.name
  project                  = var.project_id
  ip_cidr_range            = var.subnet_info.ip_cidr_range #"10.2.0.0/16"
  region                   = var.region
  network                  = var.network
  private_ip_google_access = var.subnet_info.private_ip_google_access
}

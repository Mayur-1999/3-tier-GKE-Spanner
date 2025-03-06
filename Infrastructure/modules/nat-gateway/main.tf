resource "google_compute_router" "router" {
  name    = "${var.gateway_name}-router"
  region  = var.region
  network = var.network
  project = var.project_id
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = var.gateway_name
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  project                            = var.project_id
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

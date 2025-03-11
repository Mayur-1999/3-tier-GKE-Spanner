resource "google_compute_address" "reserved_ip" {
  name         = var.ip_name
  project      = var.project_id
  address_type = "EXTERNAL"
}

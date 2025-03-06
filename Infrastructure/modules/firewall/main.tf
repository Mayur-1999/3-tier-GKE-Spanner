###############################################################################
# Firewall Configuration Module
###############################################################################

resource "google_compute_firewall" "firewall" {
  project       = var.project_id
  name          = var.firewall_info.name
  network       = var.network
  description   = var.firewall_info.description
  direction     = var.firewall_info.direction #"INGRESS"
  priority      = var.firewall_info.priority
  source_ranges = var.firewall_info.source_ranges

  dynamic "allow" {
    for_each = var.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = var.deny
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }

  source_tags = ["foo"]
  target_tags = ["web"]
}





















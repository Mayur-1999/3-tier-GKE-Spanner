#vpc
# output "network" {
#   value = google_compute_network.network
# }

output "network_self_link" {
  value = google_compute_network.network.self_link
}

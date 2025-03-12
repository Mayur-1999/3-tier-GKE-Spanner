#vpc
# output "network" {
#   value = google_compute_network.network
# }

output "network_self_link" {
  value = google_compute_network.network[0].self_link
}

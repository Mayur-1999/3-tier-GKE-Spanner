#vpc
# output "network" {
#   value = google_compute_network.network
# }

output "network" {
  value = google_compute_network.network.self_link
}

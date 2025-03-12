#subnet
output "subnet" {
  value       = google_compute_subnetwork.subnetwork.self_link
  description = "The created subnet resources"
}

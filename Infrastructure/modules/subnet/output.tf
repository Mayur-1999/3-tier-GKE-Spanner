#subnet
output "subnet" {
  value       = google_compute_subnetwork.subnetwork
  description = "The created subnet resources"
}

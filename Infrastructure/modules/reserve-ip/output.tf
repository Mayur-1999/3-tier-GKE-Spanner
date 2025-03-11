output "reserved_ip" {
  description = "Self link of ip address"
  value       = google_compute_address.reserved_ip.id
}

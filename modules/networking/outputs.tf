output "network" {
  value       = google_compute_network.this
  description = "The network self link."
}

output "subnetwork" {
  value       = google_compute_subnetwork.this
  description = "The subnetwork self link."
}

output "connection" {
  description = "The private connection string between the network and GCP services."
  value       = google_service_networking_connection.this
}

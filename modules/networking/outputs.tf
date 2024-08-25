output "network_self_link" {
  value       = google_compute_network.this.self_link
  description = "The network self link."
}

output "subnetwork_self_link" {
  value       = google_compute_subnetwork.this.self_link
  description = "The subnetwork self link."
}

output "network_connection_string" {
  description = "The private connection string between the network and GCP services."
  value       = google_service_networking_connection.this.network
}

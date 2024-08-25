resource "google_compute_network" "this" {
  name                    = "${var.namespace}-vpc"
  description             = "Ctrlplane VPC Network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name          = "${var.namespace}-subnet"
  ip_cidr_range = "10.10.0.0/16"
  network       = google_compute_network.this.self_link
}

resource "google_compute_global_address" "this" {
  name          = "${var.namespace}-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.this.id
}

resource "google_service_networking_connection" "this" {
  network                 = google_compute_network.this.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.this.name]
}

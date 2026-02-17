# -----------------------------------------------------------------------------
# VPC + Subnet
# -----------------------------------------------------------------------------

resource "google_compute_network" "main" {
  name                    = "${var.name}-vpc"
  auto_create_subnetworks = false

  depends_on = [google_project_service.apis]
}

resource "google_compute_subnetwork" "main" {
  name          = "${var.name}-subnet"
  ip_cidr_range = "10.0.0.0/20"
  region        = var.region
  network       = google_compute_network.main.id

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.4.0.0/14"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.8.0.0/20"
  }
}

# -----------------------------------------------------------------------------
# Private Service Access (for Cloud SQL private IP)
# -----------------------------------------------------------------------------

resource "google_compute_global_address" "private_ip_range" {
  name          = "${var.name}-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

resource "google_service_networking_connection" "private_vpc" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]

  depends_on = [google_project_service.apis]
}

# -----------------------------------------------------------------------------
# Static IP for Ingress
# -----------------------------------------------------------------------------

resource "google_compute_global_address" "ingress" {
  name = "${var.name}-ingress-ip"

  depends_on = [google_project_service.apis]
}

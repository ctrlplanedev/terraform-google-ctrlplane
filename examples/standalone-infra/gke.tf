resource "google_container_cluster" "main" {
  name     = "${var.name}-cluster"
  location = var.region

  enable_autopilot = true

  network    = google_compute_network.main.id
  subnetwork = google_compute_subnetwork.main.id

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  deletion_protection = false

  depends_on = [google_project_service.apis]
}

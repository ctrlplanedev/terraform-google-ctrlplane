resource "google_container_cluster" "this" {
  name = "${var.namespace}-cluster"

  network    = var.network_self_link
  subnetwork = var.subnetwork_self_link

  enable_autopilot = true

  deletion_protection = var.deletion_protection

  node_config {
    service_account = var.service_account_email
  }

  release_channel {
    channel = "STABLE"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

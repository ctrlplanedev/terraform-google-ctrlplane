data "google_client_config" "current" {}

locals {
  project_id = data.google_client_config.current.project
}

resource "google_container_cluster" "this" {
  name = var.namespace

  network    = var.network_self_link
  subnetwork = var.subnetwork_self_link

  enable_autopilot = true

  deletion_protection = var.deletion_protection

  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
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

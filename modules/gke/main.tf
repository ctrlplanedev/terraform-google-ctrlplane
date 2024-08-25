
resource "google_container_cluster" "ctrlplane" {
  name = "${var.namespace}-cluster"

  network    = var.network.self_link
  subnetwork = var.subnetwork.self_link

  release_channel {
    channel = "STABLE"
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Disable client certificate authentication, which reduces the attack surface 
  # for the cluster by disabling this deprecated feature. It defaults to false, 
  # but this will make it explicit and quiet some security tooling.
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

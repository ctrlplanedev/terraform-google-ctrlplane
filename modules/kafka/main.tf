data "google_client_config" "current" {}

resource "google_managed_kafka_cluster" "this" {
  project    = data.google_client_config.current.project
  cluster_id = "${var.namespace}-kafka-cluster"
  location   = data.google_client_config.current.region

  capacity_config {
    vcpu_count   = 3
    memory_bytes = 32 * 1024 * 1024 * 1024
  }

  gcp_config {
    access_config {
      network_configs {
        subnet = var.subnetwork_self_link
      }
    }
  }
}

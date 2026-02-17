resource "google_managed_kafka_cluster" "main" {
  cluster_id = "${var.name}-kafka"
  location   = var.region

  capacity_config {
    vcpu_count   = var.kafka_vcpu_count
    memory_bytes = var.kafka_memory_bytes
  }

  gcp_config {
    access_config {
      network_configs {
        subnet = google_compute_subnetwork.main.id
      }
    }
  }

  rebalance_config {
    mode = "NO_REBALANCE"
  }

  depends_on = [google_project_service.apis]
}

resource "google_managed_kafka_topic" "workspace_events" {
  cluster  = google_managed_kafka_cluster.main.cluster_id
  topic_id = "workspace-events"
  location = var.region

  partition_count    = 3
  replication_factor = 3

  configs = {
    "retention.ms" = "604800000" # 7 days
  }
}

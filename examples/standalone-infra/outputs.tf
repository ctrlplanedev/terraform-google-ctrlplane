# -----------------------------------------------------------------------------
# GKE
# -----------------------------------------------------------------------------

output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.main.name
}

output "gke_cluster_endpoint" {
  description = "GKE cluster API endpoint"
  value       = google_container_cluster.main.endpoint
  sensitive   = true
}

output "gke_get_credentials" {
  description = "Run this command to configure kubectl"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.main.name} --region ${var.region} --project ${var.project_id}"
}

# -----------------------------------------------------------------------------
# PostgreSQL
# -----------------------------------------------------------------------------

output "postgres_host" {
  description = "Cloud SQL private IP address"
  value       = google_sql_database_instance.main.private_ip_address
}

output "postgres_port" {
  description = "PostgreSQL port"
  value       = "5432"
}

output "postgres_user" {
  description = "PostgreSQL username"
  value       = google_sql_user.ctrlplane.name
}

output "postgres_password" {
  description = "PostgreSQL password"
  value       = random_password.postgres.result
  sensitive   = true
}

output "postgres_database" {
  description = "PostgreSQL database name"
  value       = google_sql_database.ctrlplane.name
}

# -----------------------------------------------------------------------------
# Kafka
# -----------------------------------------------------------------------------

output "kafka_bootstrap_servers" {
  description = "Managed Kafka bootstrap server address"
  value       = "bootstrap.${google_managed_kafka_cluster.main.cluster_id}.${var.region}.managedkafka.${var.project_id}.cloud.goog:9092"
}

# -----------------------------------------------------------------------------
# Ingress
# -----------------------------------------------------------------------------

output "ingress_static_ip" {
  description = "Static IP for ingress - create a DNS A record pointing your domain here"
  value       = google_compute_global_address.ingress.address
}

output "ingress_static_ip_name" {
  description = "Name of the static IP resource (use in ingress annotations)"
  value       = google_compute_global_address.ingress.name
}

# -----------------------------------------------------------------------------
# Helm Values
# -----------------------------------------------------------------------------

output "helm_values" {
  description = "Paste this into your values.yaml override (fill in fqdn + ingress class)"
  sensitive   = true
  value       = yamlencode({
    global = {
      fqdn = "REPLACE_WITH_YOUR_DOMAIN"
      postgresql = {
        user     = google_sql_user.ctrlplane.name
        password = random_password.postgres.result
        host     = google_sql_database_instance.main.private_ip_address
        port     = "5432"
        database = google_sql_database.ctrlplane.name
      }
      kafka = {
        brokers = "bootstrap.${google_managed_kafka_cluster.main.cluster_id}.${var.region}.managedkafka.${var.project_id}.cloud.goog:9092"
        groupId = "workspace-engine"
        topic   = "workspace-events"
      }
    }
    ingress = {
      create = true
      class  = "gce"
      annotations = {
        "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.ingress.name
      }
    }
  })
}

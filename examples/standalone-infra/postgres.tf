resource "random_password" "postgres" {
  length  = 32
  special = false
}

resource "google_sql_database_instance" "main" {
  name             = "${var.name}-postgres"
  database_version = var.postgres_version
  region           = var.region

  settings {
    tier            = var.postgres_tier
    disk_size       = var.postgres_disk_size_gb
    disk_autoresize = true

    availability_type = "ZONAL"

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.main.id
      enable_private_path_for_google_cloud_services = true
    }

    backup_configuration {
      enabled    = true
      start_time = "03:00"
    }
  }

  deletion_protection = false

  depends_on = [
    google_service_networking_connection.private_vpc,
    google_project_service.apis,
  ]
}

resource "google_sql_database" "ctrlplane" {
  name     = "ctrlplane"
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "ctrlplane" {
  name     = "ctrlplane"
  instance = google_sql_database_instance.main.name
  password = random_password.postgres.result
}

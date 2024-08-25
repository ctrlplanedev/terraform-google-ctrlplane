resource "random_string" "master_password" {
  length  = 32
  special = false
}

resource "random_pet" "postgres" {
  length = 2
  keepers = {
    namespace = var.database_version
  }
}

locals {
  database_name        = "ctrlplane"
  master_username      = "ctrlplane"
  master_password      = random_string.master_password.result
  master_instance_name = "${var.namespace}-${random_pet.postgres.id}"
}

resource "google_sql_database_instance" "postgres" {
  name             = local.master_instance_name
  database_version = var.database_version

  settings {
    tier = var.tier
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_connection.network
    }
  }
}

resource "google_sql_database" "ctrlplane" {
  name     = local.database_name
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "ctrlplane" {
  instance = google_sql_database_instance.postgres.name
  name     = local.master_username
  password = local.master_password
}


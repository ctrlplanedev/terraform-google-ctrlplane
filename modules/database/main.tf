resource "random_string" "this" {
  length  = 32
  special = false
}

locals {
  database_name   = "ctrlplane"
  master_username = "ctrlplane"
  master_password = random_string.this.result
}

resource "google_sql_database_instance" "this" {
  name             = var.namespace
  database_version = var.postgres_version

  settings {
    tier                        = var.postgres_tier
    deletion_protection_enabled = var.deletion_protection

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_connection_string
    }
  }
}

resource "google_sql_database" "this" {
  name     = local.database_name
  instance = google_sql_database_instance.this.name
}

resource "google_sql_user" "this" {
  instance = google_sql_database_instance.this.name
  name     = local.master_username
  password = local.master_password
}


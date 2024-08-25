resource "random_string" "this" {
  length  = 32
  special = false
}

resource "random_pet" "this" {
  length = 2
  keepers = {
    namespace = var.database_version
  }
}

locals {
  database_name        = "ctrlplane"
  master_username      = "ctrlplane"
  master_password      = random_string.this.result
  master_instance_name = "${var.namespace}-${random_pet.this.id}"
}

resource "google_sql_database_instance" "this" {
  name             = local.master_instance_name
  database_version = var.database_version

  settings {
    tier = var.postgres_tier
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


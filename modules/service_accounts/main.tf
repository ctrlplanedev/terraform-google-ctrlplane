data "google_client_config" "current" {}

resource "random_id" "this" {
  byte_length = 30
  prefix      = "${var.namespace}-sa-"
}

resource "google_service_account" "this" {
  account_id   = substr(random_id.this.dec, 0, 30)
  display_name = "${var.namespace} Ctrlplane"
  description  = "Service Account used by Ctrlplane."
}

locals {
  sa_member  = "serviceAccount:${google_service_account.this.email}"
  project_id = data.google_client_config.current.project
}

resource "google_project_iam_member" "this" {
  project = local.project_id
  role    = "roles/cloudsql.client"
  member  = local.sa_member
}

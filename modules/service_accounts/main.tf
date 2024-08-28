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

resource "google_project_iam_member" "cloudsql_client" {
  project = local.project_id
  role    = "roles/cloudsql.client"
  member  = local.sa_member
}

resource "google_project_iam_member" "sa_creator" {
  project = local.project_id
  role    = "roles/iam.serviceAccountCreator"
  member  = local.sa_member
}

resource "google_service_account_iam_binding" "this" {
  service_account_id = google_service_account.this.id
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${local.project_id}.svc.id.goog[default/ctrlplane-${var.namespace}-sa]"
  ]
}

data "google_client_config" "current" {}

resource "google_service_account" "gke" {
  account_id   = "${var.namespace}-gke"
  display_name = "${var.namespace} Ctrlplane"
  description  = "Service Account used by Ctrlplane."
}

locals {
  sa_member  = "serviceAccount:${google_service_account.gke.email}"
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

locals {
  gke_namespace = "default"
}

resource "google_service_account_iam_binding" "gke" {
  service_account_id = google_service_account.gke.id
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${local.project_id}.svc.id.goog[${local.gke_namespace}/ctrlplane-webservice]",
    "serviceAccount:${local.project_id}.svc.id.goog[${local.gke_namespace}/ctrlplane-job-policy-checker]",
    "serviceAccount:${local.project_id}.svc.id.goog[${local.gke_namespace}/ctrlplane-migrations]"
  ]
}

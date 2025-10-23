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

locals {
  gke_namespace = "default"
  members = [
    "serviceAccount:${local.project_id}.svc.id.goog[${local.gke_namespace}/ctrlplane-webservice]",
    "serviceAccount:${local.project_id}.svc.id.goog[${local.gke_namespace}/ctrlplane-jobs]",
    "serviceAccount:${local.project_id}.svc.id.goog[${local.gke_namespace}/ctrlplane-migrations]",
    "serviceAccount:${local.project_id}.svc.id.goog[${local.gke_namespace}/ctrlplane-event-worker]",
    "serviceAccount:${local.project_id}.svc.id.goog[${local.gke_namespace}/ctrlplane-event-queue]",
    "serviceAccount:${local.project_id}.svc.id.goog[${local.gke_namespace}/ctrlplane-workspace-engine]",
  ]
}

resource "google_service_account_iam_member" "gke_workload_identity" {
  for_each = { for idx, member in local.members : idx => member }

  service_account_id = google_service_account.gke.id
  role               = "roles/iam.workloadIdentityUser"
  member             = each.value
}

resource "google_project_iam_member" "gke_workload_sa_admin" {
  for_each = { for idx, member in local.members : idx => member }

  project = local.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = each.value
}

resource "google_project_iam_member" "gke_workload_sa_user" {
  for_each = { for idx, member in local.members : idx => member }

  project = local.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = each.value
}

resource "google_project_iam_member" "gke_workload_sa_token_creator" {
  for_each = { for idx, member in local.members : idx => member }

  project = local.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = each.value
}

resource "google_project_iam_member" "gke_sa_token_creator" {
  project = local.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = local.sa_member
}

resource "google_storage_bucket_iam_member" "gke_sa_bucket_rw" {
  bucket = var.bucket_name
  role   = "roles/storage.objectAdmin"
  member = local.sa_member
}

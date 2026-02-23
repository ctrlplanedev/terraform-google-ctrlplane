resource "google_service_account" "ctrlplane" {
  account_id   = "${var.name}-ctrlplane"
  display_name = "Ctrlplane ${var.name}"
  project      = var.project_id
}

resource "google_project_iam_member" "kafka_client" {
  project = var.project_id
  role    = "roles/managedkafka.client"
  member  = "serviceAccount:${google_service_account.ctrlplane.email}"
}

resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.ctrlplane.email}"
}

resource "google_service_account_iam_member" "workload_identity" {
  service_account_id = google_service_account.ctrlplane.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[ctrlplane/ctrlplane]"
}

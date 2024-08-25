data "google_client_config" "current" {}

resource "random_id" "main" {
  # 30 bytes ensures that enough characters are generated to satisfy the service account ID requirements, regardless of
  # the prefix.
  byte_length = 30
  prefix      = "${var.namespace}-sa-"
}

resource "google_service_account" "main" {
  # Limit the string used to 30 characters.
  account_id   = substr(random_id.main.dec, 0, 30)
  display_name = "Ctrlplane"
  description  = "Service Account used by Ctrlplane."
}

locals {
  sa_member  = "serviceAccount:${google_service_account.main.email}"
  project_id = data.google_client_config.current.project
}

# Cloud SQL Client role allows service account members connectivity access to
# Cloud SQL instances
resource "google_project_iam_member" "cloudsql_client" {
  project = local.project_id
  role    = "roles/cloudsql.client"
  member  = local.sa_member
}

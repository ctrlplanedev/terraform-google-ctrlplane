
data "google_client_config" "current" {}

resource "google_storage_bucket" "this" {
  name     = var.namespace
  location = data.google_client_config.current.region
  project  = data.google_client_config.current.project

  uniform_bucket_level_access = true
  force_destroy               = !var.deletion_protection

  labels = var.labels

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT"]
    response_header = ["*"]
    max_age_seconds = 3000
  }
}
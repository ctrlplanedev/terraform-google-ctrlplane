provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "ctrlplane" {
  source    = "../"
  namespace = var.namespace
}

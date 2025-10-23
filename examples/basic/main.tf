provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "current" {}

provider "helm" {
  kubernetes {
    host                   = "https://${module.ctrlplane.cluster_endpoint}"
    cluster_ca_certificate = base64decode(module.ctrlplane.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

module "ctrlplane" {
  source    = "../../"
  namespace = var.namespace
  domains   = ["example.com"]
  fqdn      = "example.com"
  google_auth = {
    client_id     = "1234567890"
    client_secret = "1234567890"
  }
}

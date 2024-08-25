module "project_factory_project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 16.0"
  project_id                  = null
  disable_dependent_services  = false
  disable_services_on_destroy = false
  activate_apis = [
    "sqladmin.googleapis.com",          // Database
    "networkmanagement.googleapis.com", // Networking
    "servicenetworking.googleapis.com", // Networking
  ]
}

module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace

  depends_on = [module.project_factory_project_services]
}

locals {
  network_connection_string = try(module.networking.network_connection_string)
  network_self_link         = try(module.networking.network_self_link)
  subnetwork_self_link      = try(module.networking.subnetwork_self_link)
}

module "database" {
  source    = "./modules/database"
  namespace = var.namespace

  network_connection_string = local.network_connection_string

  postgres_tier = var.postgres_tier

  depends_on = [module.networking]
}

module "service_accounts" {
  source    = "./modules/service_accounts"
  namespace = var.namespace
}

module "gke" {
  source    = "./modules/gke"
  namespace = var.namespace

  network_self_link    = local.network_self_link
  subnetwork_self_link = local.subnetwork_self_link

  service_account_email = module.service_accounts.service_account_email

  depends_on = [module.networking, module.service_accounts]
}

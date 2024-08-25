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
}

locals {
  network_connection = try(module.networking.connection)
  network            = try(module.networking.network)
  subnetwork         = try(module.networking.subnetwork)
}

module "database" {
  source             = "./modules/database"
  namespace          = var.namespace
  network_connection = local.network_connection
}

module "service_accounts" {
  source    = "./modules/service_accounts"
  namespace = var.namespace
}

module "gke" {
  source          = "./modules/gke"
  namespace       = var.namespace
  network         = local.network
  subnetwork      = local.subnetwork
  service_account = module.service_accounts.service_account
}

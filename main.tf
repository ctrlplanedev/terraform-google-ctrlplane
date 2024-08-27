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

module "database" {
  source    = "./modules/database"
  namespace = var.namespace

  network_connection_string = module.networking.network_connection_string

  postgres_tier    = var.postgres_tier
  postgres_version = var.postgres_version

  delete_protection = var.database_delete_protection

  depends_on = [module.networking]
}

module "redis" {
  source    = "./modules/redis"
  namespace = var.namespace

  tier           = var.redis_tier
  memory_size_gb = var.redis_memory_size_gb

  network_id = module.networking.network_id
}

module "service_accounts" {
  source    = "./modules/service_accounts"
  namespace = var.namespace
}

module "gke" {
  source    = "./modules/gke"
  namespace = var.namespace

  deletion_protection = var.gke_delete_protection

  network_self_link    = module.networking.network_self_link
  subnetwork_self_link = module.networking.subnetwork_self_link

  service_account_email = module.service_accounts.service_account_email

  depends_on = [module.networking, module.service_accounts]
}

module "project_factory_project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 16.0"
  project_id                  = null
  disable_dependent_services  = false
  disable_services_on_destroy = false
  activate_apis = [
    "iam.googleapis.com",
    "sqladmin.googleapis.com",
    "networkmanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "redis.googleapis.com",
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

  network_connection_string = module.networking.connection.network

  postgres_tier    = var.postgres_tier
  postgres_version = var.postgres_version

  deletion_protection = var.deletion_protection

  depends_on = [module.networking]
}

module "redis" {
  source    = "./modules/redis"
  namespace = var.namespace

  tier                = var.redis_tier
  memory_size_gb      = var.redis_memory_size_gb
  rdb_snapshot_period = var.redis_rdb_snapshot_period

  network_id = module.networking.network.id

  depends_on = [module.networking]
}

module "gke" {
  source    = "./modules/gke"
  namespace = var.namespace

  deletion_protection = var.deletion_protection

  network_self_link    = module.networking.network.self_link
  subnetwork_self_link = module.networking.subnetwork.self_link

  depends_on = [module.networking]
}

module "service_accounts" {
  source    = "./modules/service_accounts"
  namespace = var.namespace

  depends_on = [module.gke]
}

resource "google_compute_global_address" "this" {
  name = "${var.namespace}-address"
}

resource "google_compute_managed_ssl_certificate" "this" {
  name = "${var.namespace}-cert"

  managed {
    domains = var.domains
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "helm_release" {
  count  = var.deploy_helm_release ? 1 : 0
  source = "./modules/helm_release"

  fqdn = var.fqdn

  chart_version = var.chart_version

  google_auth = var.google_auth

  github_bot = var.github_bot

  values = var.helm_values

  redis_host     = module.redis.redis_host
  redis_port     = module.redis.redis_port
  redis_password = module.redis.redis_auth_string

  postgres_user     = module.database.sql_user_username
  postgres_password = module.database.sql_user_password
  postgres_host     = module.database.database_instance_private_ip_address
  postgres_port     = 5432
  postgres_database = module.database.database_name

  service_account_email = module.service_accounts.gke_service_account.email

  global_static_ip_name = google_compute_global_address.this.name
  pre_shared_cert       = google_compute_managed_ssl_certificate.this.name

  depends_on = [module.gke, module.database, module.redis, module.service_accounts]
}

locals {
  image_tags = {
    "migrations.image.tag"         = "26397ff",
    "webservice.image.tag"         = "0d18a53",
    "event-worker.image.tag"       = "0d18a53",
    "job-policy-checker.image.tag" = "0d18a53",
  }

  postgres_settings = {
    "global.postgresql.user"     = var.postgres_user,
    "global.postgresql.password" = var.postgres_password,
    "global.postgresql.host"     = var.postgres_host,
    "global.postgresql.port"     = var.postgres_port,
    "global.postgresql.database" = var.postgres_database,
  }

  auth_providers_settings = {
    "global.authProviders.google.clientId"     = var.google_auth.client_id,
    "global.authProviders.google.clientSecret" = var.google_auth.client_secret,
  }

  redis_settings = {
    "global.redis.host"     = var.redis_host,
    "global.redis.password" = var.redis_password,
    "global.redis.port"     = var.redis_port,
  }

  ingress_annotations = {
    "ingress.annotations.kubernetes\\.io/ingress\\.class"                 = "gce",
    "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name" = var.global_static_ip_name,
    "ingress.annotations.ingress\\.gcp\\.kubernetes\\.io/pre-shared-cert" = var.pre_shared_cert,
  }

  service_account_annotations = {
    "webservice.serviceAccount.create"                                  = true,
    "webservice.annotations.iam\\.gke\\.io/gcp-service-account"         = var.service_account_email,
    "job-policy-checker.serviceAccount.create"                          = true,
    "job-policy-checker.annotations.iam\\.gke\\.io/gcp-service-account" = var.service_account_email,
    "migrations.serviceAccount.create"                                  = true,
    "migrations.annotations.iam\\.gke\\.io/gcp-service-account"         = var.service_account_email,
    "event-worker.serviceAccount.create"                                = true,
    "event-worker.annotations.iam\\.gke\\.io/gcp-service-account"       = var.service_account_email,
  }
}

resource "helm_release" "this" {
  name       = "ctrlplane"
  chart      = "ctrlplane"
  repository = "https://charts.ctrlplane.dev/"
  version    = "0.1.15"

  dynamic "set" {
    for_each = merge(
      local.image_tags,
      local.auth_providers_settings,
      local.postgres_settings,
      local.redis_settings,
      local.ingress_annotations,
      local.service_account_annotations
    )
    content {
      name  = set.key
      value = set.value
    }
  }
}

locals {

  other_settings = {
    "global.fqdn" = var.fqdn,
  }

  image_tags = {
    "migrations.image.tag"         = "8cce786",
    "webservice.image.tag"         = "8adc7da",
    "event-worker.image.tag"       = "8cce786",
    "job-policy-checker.image.tag" = "8cce786",
  }

  postgres_settings = {
    "global.postgresql.user"     = var.postgres_user,
    "global.postgresql.password" = var.postgres_password,
    "global.postgresql.host"     = var.postgres_host,
    "global.postgresql.port"     = var.postgres_port,
    "global.postgresql.database" = var.postgres_database,
  }

  integrations_settings = var.github_bot != null ? {
    "global.integrations.github.bot.name"         = var.github_bot.name
    "global.integrations.github.bot.appId"        = var.github_bot.app_id
    "global.integrations.github.bot.clientId"     = var.github_bot.client_id
    "global.integrations.github.bot.clientSecret" = var.github_bot.client_secret
    "global.integrations.github.bot.privateKey"   = var.github_bot.client_private_key
  } : {}

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
    "webservice.serviceAccount.create"                                                 = true,
    "webservice.serviceAcount.annotations.iam\\.gke\\.io/gcp-service-account"          = var.service_account_email,
    "job-policy-checker.serviceAccount.create"                                         = true,
    "job-policy-checker.serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account" = var.service_account_email,
    "migrations.serviceAccount.create"                                                 = true,
    "migrations.serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"         = var.service_account_email,
    "event-worker.serviceAccount.create"                                               = true,
    "event-worker.serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"       = var.service_account_email,
  }
}

resource "helm_release" "this" {
  name       = "ctrlplane"
  chart      = "ctrlplane"
  repository = "https://charts.ctrlplane.dev/"
  version    = var.chart_version

  dynamic "set" {
    for_each = merge(
      local.other_settings,
      local.image_tags,
      local.auth_providers_settings,
      local.postgres_settings,
      local.redis_settings,
      local.ingress_annotations,
      local.service_account_annotations,
      local.integrations_settings,
    )
    content {
      name  = set.key
      value = set.value
    }
  }
}

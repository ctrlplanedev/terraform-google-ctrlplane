resource "kubernetes_manifest" "backend_config" {
  manifest = {
    "apiVersion" = "cloud.google.com/v1"
    "kind"       = "BackendConfig"
    "metadata" = {
      "name"      = "ctrlplane-websocket"
      "namespace" = "default"
    }
    "spec" = {
      "timeoutSec" = 1209600 # 2 weeks
    }
  }
}

locals {

  config = {
    global = {
      fqdn = var.fqdn,
      postgresql = {
        user     = var.postgres_user,
        password = var.postgres_password,
        host     = var.postgres_host,
        port     = tostring(var.postgres_port),
        database = var.postgres_database,
      },

      redis = {
        host     = var.redis_host,
        password = var.redis_password,
        port     = tostring(var.redis_port),
      },
    },

    webservice   = { image = { tag = "8264bfc" } },
    migrations   = { image = { tag = "c19dd39" } },
    event-worker = { image = { tag = "8264bfc" } },
    jobs         = { image = { tag = "8264bfc" } },

    pty-proxy = {
      image = { tag = "8264bfc" }
      service = {
        annotations = {
          "beta.cloud.google.com/backend-config" = "{\"default\": \"ctrlplane-websocket\"}"
        }
      }
    },
  }

  github_settings = var.github_bot != null ? {
    "global.integrations.github.bot.name"          = var.github_bot.name
    "global.integrations.github.bot.appId"         = var.github_bot.app_id
    "global.integrations.github.bot.clientId"      = var.github_bot.client_id
    "global.integrations.github.bot.clientSecret"  = var.github_bot.client_secret
    "global.integrations.github.bot.privateKey"    = var.github_bot.client_private_key
    "global.integrations.github.bot.webhookSecret" = var.github_bot.webhook_secret
  } : {}

  azure_app_settings = var.azure_app != null ? {
    "global.integrations.azure.appClientId"     = var.azure_app.client_id
    "global.integrations.azure.appClientSecret" = var.azure_app.client_secret
  } : {}

  auth_providers_settings = {
    "global.authProviders.google.clientId"     = var.google_auth.client_id,
    "global.authProviders.google.clientSecret" = var.google_auth.client_secret,
  }

  ingress_annotations = {
    "ingress.annotations.kubernetes\\.io/ingress\\.class"                 = "gce",
    "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name" = var.global_static_ip_name,
    "ingress.annotations.ingress\\.gcp\\.kubernetes\\.io/pre-shared-cert" = var.pre_shared_cert,
  }

  service_account_annotations = {
    "webservice.serviceAccount.create"                                           = true,
    "webservice.serviceAcount.annotations.iam\\.gke\\.io/gcp-service-account"    = var.service_account_email,
    "jobs.serviceAccount.create"                                                 = true,
    "jobs.serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"         = var.service_account_email,
    "migrations.serviceAccount.create"                                           = true,
    "migrations.serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"   = var.service_account_email,
    "event-worker.serviceAccount.create"                                         = true,
    "event-worker.serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account" = var.service_account_email,
  }
}

resource "helm_release" "this" {
  name       = "ctrlplane"
  chart      = "ctrlplane"
  repository = "https://charts.ctrlplane.dev/"
  version    = var.chart_version

  dynamic "set" {
    for_each = merge(
      local.auth_providers_settings,
      local.ingress_annotations,
      local.service_account_annotations,
      local.github_settings,
      local.azure_app_settings,
    )

    content {
      name  = set.key
      value = set.value
    }
  }

  values = [yamlencode(local.config), yamlencode(var.values)]
}

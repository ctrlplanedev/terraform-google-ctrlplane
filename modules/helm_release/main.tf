resource "helm_release" "this" {
  name       = "ctrlplane"
  chart      = "ctrlplane"
  repository = "https://charts.ctrlplane.dev/"

  set {
    name  = "global.redis.host"
    value = var.redis_host
  }

  set {
    name  = "global.redis.port"
    value = var.redis_port
  }

  set {
    name  = "global.redis.password"
    value = var.redis_password
  }

  set {
    name  = "global.postgresql.user"
    value = var.postgres_user
  }

  set {
    name  = "global.postgresql.password"
    value = var.postgres_password
  }

  set {
    name  = "global.postgresql.host"
    value = var.postgres_host
  }

  set {
    name  = "global.postgresql.port"
    value = var.postgres_port
  }

  set {
    name  = "global.postgresql.database"
    value = var.postgres_database
  }

  set {
    name  = "webservice.serviceAccount.create"
    value = true
  }

  set {
    name = "webservice.serviceAccount.annotations"
    value = yamlencode({
      "iam.gke.io/gcp-service-account" = var.service_account_email
    })
  }

  set {
    name  = "job-policy-checker.serviceAccount.create"
    value = true
  }

  set {
    name = "job-policy-checker.serviceAccount.annotations"
    value = yamlencode({
      "iam.gke.io/gcp-service-account" = var.service_account_email
    })
  }

  set {
    name  = "migrations.serviceAccount.create"
    value = true
  }

  set {
    name = "migrations.serviceAccount.annotations"
    value = yamlencode({
      "iam.gke.io/gcp-service-account" = var.service_account_email
    })
  }
}

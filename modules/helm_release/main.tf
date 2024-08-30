resource "helm_release" "this" {
  name       = "ctrlplane"
  chart      = "ctrlplane"
  repository = "https://charts.ctrlplane.dev/"
  version    = "0.1.13"

  set {
    name  = "migrations.image.tag"
    value = "bf077e5"
  }


  set {
    name  = "webservice.image.tag"
    value = "72ce135"
  }


  set {
    name  = "event-worker.image.tag"
    value = "72ce135"
  }


  set {
    name  = "job-policy-checker.image.tag"
    value = "72ce135"
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
    name  = "global.redis.host"
    value = var.redis_host
  }

  set {
    name  = "global.redis.password"
    value = var.redis_password
  }

  set {
    name  = "global.redis.port"
    value = var.redis_port
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "gce"
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name"
    value = var.global_static_ip_name
  }

  set {
    name = "ingress.annotations.ingress\\.gcp\\.kubernetes\\.io/pre-shared-cert"
    value = var.pre_shared_cert
  }

  # set {
  #   name  = "ingress.annotations.kubernetes\\.io/ingress\\.allow-http"
  #   value = "true " # idk how to make this a string not a booleaning
  # }

  set {
    name  = "webservice.annotations.iam\\.gke\\.io/gcp-service-account"
    value = var.service_account_email
  }

  set {
    name  = "job-policy-checker.annotations.iam\\.gke\\.io/gcp-service-account"
    value = var.service_account_email
  }

  set {
    name  = "migrations.annotations.iam\\.gke\\.io/gcp-service-account"
    value = var.service_account_email
  }
}

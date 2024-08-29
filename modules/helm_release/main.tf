resource "helm_release" "this" {
  name       = "ctrlplane"
  chart      = "ctrlplane"
  repository = "https://charts.ctrlplane.dev/"


  set {
    name = "global"
    value = yamlencode({
      "postgres" = {
        "user"     = var.postgres_user
        "password" = var.postgres_password
        "host"     = var.postgres_host
        "port"     = var.postgres_port
        "database" = var.postgres_database
      }

      "reds" = {
        "host"     = var.redis_host
        "port"     = var.redis_port
        "password" = var.redis_password
      }
    })
  }

  set {
    name = "ingress"
    value = yamlencode({
      "enabled" = true
      "annotations" = {
        "kubernetes.io/ingress.class"                 = "gce"
        "kubernetes.io/ingress.global-static-ip-name" = var.global_static_ip_name
        "ingress.gcp.kubernetes.io/pre-shared-cert"   = var.pre_shared_cert
        "kubernetes.io/ingress.allow-http"            = "false"
      }
    })
  }

  set {
    name = "webservice"
    value = yamlencode({
      "serviceAccount" = {
        "create" = true
        "annotations" = {
          "iam.gke.io/gcp-service-account" = var.service_account_email
        }
      }
    })
  }

  set {
    name = "job-policy-checker"
    value = yamlencode({
      "serviceAccount" = {
        "create" = true
        "annotations" = {
          "iam.gke.io/gcp-service-account" = var.service_account_email
        }
      }
    })
  }

  set {
    name = "migrations"
    value = yamlencode({
      "serviceAccount" = {
        "create" = true
        "annotations" = {
          "iam.gke.io/gcp-service-account" = var.service_account_email
        }
      }
    })
  }
}

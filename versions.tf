terraform {
  required_version = "~> 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.42"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.33"
    }
  }
}

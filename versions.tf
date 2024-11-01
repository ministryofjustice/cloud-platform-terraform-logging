terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.12.1"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.1.2"
    }
  }
  required_version = ">= 1.2.5"
}


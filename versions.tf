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
      source  = "gavinbunney/kubectl"
      version = ">=1.13.2"
    }
  }
  required_version = ">= 0.14"
}


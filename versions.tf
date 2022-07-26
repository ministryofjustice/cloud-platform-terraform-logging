terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.6.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
  required_version = ">= 0.13"
}


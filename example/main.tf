provider "kubernetes" {
  version = "~> 1.11"
}

provider "helm" {
  version = "1.1.0"
  kubernetes {
  }
}

# Stable Helm Chart repository
data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}



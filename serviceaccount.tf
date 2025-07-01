locals {
  sa_name   = "fluent-bit-cp-managed"
  namespace = "logging"
  serviceaccount_rules = [
    {
      api_groups = [""]
      resources = [
        "namespaces",
        "pods",
        "events"
      ]
      verbs = [
        "get",
        "list",
        "watch"
      ]
    },
  ]
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = local.sa_name
    namespace = local.namespace
  }

  depends_on = [kubernetes_namespace.logging]
}

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = local.sa_name
  }

  dynamic "rule" {
    for_each = local.serviceaccount_rules
    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = local.sa_name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.this.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = local.namespace
  }
}


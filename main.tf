###################
# K8S - Namespace #
###################

resource "kubernetes_namespace" "logging" {
  metadata {
    name = "logging"

    labels = {
      "component"                          = "logging"
      "pod-security.kubernetes.io/enforce" = "privileged"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"                = "Logging"
      "cloud-platform.justice.gov.uk/business-unit"              = "Platforms"
      "cloud-platform.justice.gov.uk/owner"                      = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"                = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "iam.amazonaws.com/permitted"                              = ".*"
      "cloud-platform.justice.gov.uk/can-tolerate-master-taints" = "true"
      "cloud-platform.justice.gov.uk/slack-channel"              = "cloud-platform"
      "cloud-platform-out-of-hours-alert"                        = "true"
    }
  }
}

###############
# EventRouter #
###############

resource "helm_release" "eventrouter" {
  name       = "eventrouter"
  repository = "https://ministryofjustice.github.io/cloud-platform-helm-charts"
  chart      = "eventrouter"
  namespace  = kubernetes_namespace.logging.id
  version    = "0.3.3"

  set {
    name  = "sink"
    value = "stdout"
  }
}

###############
# fluent-bit #
###############

resource "helm_release" "fluent_bit" {
  count = var.enable_fluent_bit ? 1 : 0

  name       = "fluent-bit"
  chart      = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  namespace  = kubernetes_namespace.logging.id
  version    = "0.37.0"
  timeout    = 1500

  values = [templatefile("${path.module}/templates/fluent-bit.yaml.tpl", {
    opensearch_app_host             = var.opensearch_app_host
    elasticsearch_host              = var.elasticsearch_host
    elasticsearch_modsec_audit_host = var.elasticsearch_modsec_audit_host
    cluster                         = terraform.workspace
  })]

  depends_on = [
    var.dependence_prometheus
  ]
}


####################
# Network Policies #
####################

resource "kubernetes_network_policy" "default" {
  metadata {
    name      = "default"
    namespace = kubernetes_namespace.logging.id
  }

  spec {
    pod_selector {}
    ingress {
      from {
        pod_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_prometheus_scraping" {
  metadata {
    name      = "allow-prometheus-scraping"
    namespace = kubernetes_namespace.logging.id
  }

  spec {
    pod_selector {}
    ingress {
      from {
        namespace_selector {
          match_labels = {
            component = "monitoring"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

##################
# Resource Quota #
##################

resource "kubernetes_resource_quota" "namespace_quota" {
  metadata {
    name      = "namespace-quota"
    namespace = kubernetes_namespace.logging.id
  }
  spec {
    hard = {
      pods = 100
    }
  }
}

##############
# LimitRange #
##############

resource "kubernetes_limit_range" "default" {
  metadata {
    name      = "limitrange"
    namespace = kubernetes_namespace.logging.id
  }
  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "2"
        memory = "3500Mi"
      }
      default_request = {
        cpu    = "100m"
        memory = "300Mi"
      }
    }
  }
}

#########################
# prometheus rule alert #
#########################
resource "kubectl_manifest" "prometheus_rule_alert" {
  depends_on = [helm_release.fluent_bit]
  yaml_body  = file("${path.module}/resources/prometheusrule-alerts/alerts.yaml")
}


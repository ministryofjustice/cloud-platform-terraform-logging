
locals {
  delete_indices = <<-EOF
    pip3 install elasticsearch-curator==5.8.3 &&
    (curator_cli \
      --host ${var.elasticsearch_host} \
      --use_ssl \
      --port 443 \
      delete_indices \
      --filter_list '[
        {
          "filtertype":"age",
          "source":"name",
          "direction":"older",
          "timestring": "%Y.%m.%d",
          "unit":"days",
          "unit_count":30
        }
    ]')
  EOF
}

###################
# K8S - Namespace #
###################

resource "kubernetes_namespace" "logging" {
  metadata {
    name = "logging"

    labels = {
      "component" = "logging"
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

  set {
    name  = "sink"
    value = "stdout"
  }
}

#################################
# elasticsearch curator cronjob #
#################################

resource "kubernetes_cron_job" "elasticsearch_curator_cronjob" {
  count = var.enable_curator_cronjob ? 1 : 0
  metadata {
    name      = "elasticsearch-curator-cronjob"
    namespace = "logging"
  }
  spec {
    failed_jobs_history_limit     = 3
    schedule                      = "0 1 * * *"
    successful_jobs_history_limit = 3
    job_template {
      metadata {}
      spec {
        backoff_limit = 2
        template {
          metadata {}
          spec {
            container {
              name    = "curator"
              image   = "python:3.8.7-alpine3.13"
              command = ["/bin/sh", "-c", local.delete_indices]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}

###############
# fluent-bit #
###############

resource "helm_release" "fluent_bit" {
  count = var.enable_fluent_bit ? 1 : 0

  name       = "fluent-bit"
  chart      = "fluent-bit"
  repository = "https://charts.helm.sh/stable"
  namespace  = kubernetes_namespace.logging.id
  version    = "2.10.3"

  values = [templatefile("${path.module}/templates/fluent-bit.yaml.tpl", {
    repository = var.eks ? "754256621582.dkr.ecr.eu-west-2.amazonaws.com/cloud-platform/fluent-bit" : "fluent/fluent-bit"
  })]

  depends_on = [
    kubernetes_config_map.fluent_bit_config,
    var.dependence_prometheus
  ]
}

#########################
# fluent-bit config #
#########################

resource "kubernetes_config_map" "fluent_bit_config" {
  count = var.enable_fluent_bit ? 1 : 0

  metadata {
    name      = "fluent-bit-config"
    namespace = kubernetes_namespace.logging.id
    labels = {
      "k8s-app" = "fluent-bit"
    }
  }

  data = {
    "fluent-bit.conf"        = file("${path.module}/resources/fluent-bit.config"),
    "input-kubernetes.conf"  = file("${path.module}/resources/input-kubernetes.config"),
    "filter-kubernetes.conf" = file("${path.module}/resources/filter-kubernetes.config"),
    "parsers.conf"           = file("${path.module}/resources/parsers.config"),
    "output-elasticsearch.conf" = templatefile("${path.module}/resources/output-elasticsearch.config", {
      elasticsearch_host       = var.elasticsearch_host
      elasticsearch_audit_host = var.elasticsearch_audit_host
      cluster                  = terraform.workspace
    })
  }

  lifecycle {
    ignore_changes = [metadata.0.annotations]
  }
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
        cpu    = "1"
        memory = "1000Mi"
      }
      default_request = {
        cpu    = "10m"
        memory = "400Mi"
      }
    }
  }
}

#########################
# prometheus rule alert #
#########################
resource "kubectl_manifest" "prometheus_rule_alert" {
    yaml_body = file("${path.module}/resources/prometheusrule-alerts/alerts.yaml")
}
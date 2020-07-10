
locals {
  delete_indices = <<-EOF
              pip3 install elasticsearch-curator &&
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

# Stable Helm Chart repository
data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "helm_repository" "cloud_platform" {
  name = "cloud-platform"
  url  = "https://ministryofjustice.github.io/cloud-platform-helm-charts"
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
      "cloud-platform.justice.gov.uk/business-unit"              = "cloud-platform"
      "cloud-platform.justice.gov.uk/owner"                      = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"                = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "iam.amazonaws.com/permitted"                              = ".*"
      "cloud-platform.justice.gov.uk/can-tolerate-master-taints" = "true"
    }
  }
}

##############
# fluentd-es #
##############

resource "helm_release" "fluentd_es" {
  name       = "fluentd-es"
  repository = data.helm_repository.cloud_platform.metadata[0].name
  chart      = "fluentd-es"
  namespace  = kubernetes_namespace.logging.id
  version    = "2.10.0"

  values = [templatefile("${path.module}/templates/fluentd-es.yaml.tpl", {
    elasticsearch_host       = var.elasticsearch_host
    elasticsearch_audit_host = var.elasticsearch_audit_host
    cluster_name             = terraform.workspace
  })]

  depends_on = [
    var.dependence_priority_classes,
    var.dependence_prometheus
  ]

  lifecycle {
    ignore_changes = [keyring]
  }
}

###############
# EventRouter #
###############

resource "helm_release" "eventrouter" {
  name       = "eventrouter"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "eventrouter"
  namespace  = kubernetes_namespace.logging.id

  set {
    name  = "sink"
    value = "stdout"
  }

  depends_on = [helm_release.fluentd_es]
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
              image   = "python:alpine"
              command = ["/bin/sh", "-c", local.delete_indices]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}

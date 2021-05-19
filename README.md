# cloud-platform-terraform-logging

Terraform module that deploys cloud-platform logging solution. It includes components like: fluent-bit, eventrouter, circle-ci-stats, etc

## Usage

```hcl
module "logging" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-logging?ref=0.2.0"

  elasticsearch_host       = replace(terraform.workspace, "live", "") != terraform.workspace ? "cloud-platform-live-es-endpoint" : "placeholder-elasticsearch"
  elasticsearch_audit_host = replace(terraform.workspace, "live", "") != terraform.workspace ? "cloud-platform-audit-es-endpoint" : ""

  dependence_prometheus       = module.prometheus.helm_prometheus_operator_status
  enable_curator_cronjob      = terraform.workspace == local.live_workspace ? true : false
  enable_fluent_bit           = true
}
```

<!--- BEGIN_TF_DOCS --->

<!--- END_TF_DOCS --->

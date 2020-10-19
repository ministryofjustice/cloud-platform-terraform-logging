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

## Inputs

| Name                         | Description                                        | Type | Default | Required |
|------------------------------|----------------------------------------------------|:----:|:-------:|:--------:|
| elasticsearch_host           | The ES host where logs are going to be sent        | string   | false | yes |
| elasticsearch_audit_host     | The ES audit host where logs are going to be sent  | string   | false | no |
| dependence_prometheus        | Prometheus Dependence variable                     | string   |       | yes |
| enable_fluent_bit            | Enable or not fluent-bit Helm Ch                   | string   | false | yes |
| enable_curator_cronjob       | Enable elastic-search curator cronjob              | boolean  | false | yes |

## Outputs

None

# cloud-platform-terraform-logging

Terraform module that deploys cloud-platform logging solution. It includes components like: fluentd, eventrouter, circle-ci-stats, etc

## Usage

```hcl
module "logging" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-logging?ref=0.0.1"

  elasticsearch_host       = replace(terraform.workspace, "live", "") != terraform.workspace ? "search-cloud-platform-live-dibidbfud3uww3lpxnhj2jdws4.eu-west-2.es.amazonaws.com" : "placeholder-elasticsearch"
  elasticsearch_audit_host = replace(terraform.workspace, "live", "") != terraform.workspace ? "search-cloud-platform-audit-dq5bdnjokj4yt7qozshmifug6e.eu-west-2.es.amazonaws.com" : ""

  dependence_prometheus       = module.prometheus.helm_prometheus_operator_status
  dependence_priority_classes = kubernetes_priority_class.node_critical
  enable_fluent_bit           = true
}
```

## Inputs

| Name                         | Description                                        | Type | Default | Required |
|------------------------------|----------------------------------------------------|:----:|:-------:|:--------:|
| elasticsearch_host           | The ES host where logs are going to be sent        | string   | false | yes |
| elasticsearch_audit_host     | The ES audit host where logs are going to be sent  | string   | false | no |
| dependence_prometheus        | Prometheus Dependence variable                     | string   |       | yes |
| dependence_priority_classes  | Priority class dependence                          | string   |       | yes |
| enable_fluent_bit            | Enable or not fluent-bit Helm Ch                   | string   | false | yes |

## Outputs

None

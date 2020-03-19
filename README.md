# cloud-platform-terraform-logging

Terraform module that deploys cloud-platform logging solution. It includes components like: fluentd, eventrouter, circle-ci-stats, etc

## Usage

```hcl
module "logging" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-logging?ref=0.0.1"

  # This module requires helm and OPA already deployed
  dependences = [
    null_resource.deploy,
    module.prometheus.helm_prometheus_operator_status,
    null_resource.priority_classes,
  ]
}
```

## Inputs

| Name                         | Description                                        | Type | Default | Required |
|------------------------------|----------------------------------------------------|:----:|:-------:|:--------:|
| elasticsearch_host           | The ES host where logs are going to be sent        | string   | false | yes |
| elasticsearch_audit_host     | The ES audit host where logs are going to be sent  | string   | false | no |
| dependence_prometheus        | Prometheus Dependence variable                     | string   |       | yes |
| dependence_deploy            | Deploy (helm) dependence variable                  | string   |       | yes |
| dependence_priority_classes  | Priority class dependence                          | string   |       | yes |

## Outputs

None
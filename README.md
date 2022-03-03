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
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| helm | n/a |
| kubectl | n/a |
| kubernetes | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |
| [kubectl_manifest](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) |
| [kubernetes_cron_job](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cron_job) |
| [kubernetes_limit_range](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/limit_range) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) |
| [kubernetes_network_policy](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) |
| [kubernetes_resource_quota](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/resource_quota) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dependence\_prometheus | Prometheus module dependence - it is required in order to use this module. | `any` | n/a | yes |
| eks | Required to deploy DockerHub credentials secret - Helm charts use them in imagePullSecrets field to avoid dockerhub API limitations | `bool` | `false` | no |
| elasticsearch\_audit\_host | The elasticsearch audit host where logs are going to be shipped | `any` | n/a | yes |
| elasticsearch\_host | The elasticsearch host where logs are going to be shipped | `any` | n/a | yes |
| enable\_curator\_cronjob | Enable or not elastic-search curator cronjob - which runs every day to delete indices older than 30 days | `bool` | `false` | no |
| enable\_fluent\_bit | Enable or not fluent-bit Helm Chart - change the default to true once it is ready to use | `bool` | `true` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->
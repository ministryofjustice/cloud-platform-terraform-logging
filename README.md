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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.6.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >=1.13.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.12.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.6.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >=1.13.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >=2.12.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.eventrouter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.fluent_bit](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.prometheus_rule_alert](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_limit_range.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/limit_range) | resource |
| [kubernetes_namespace.logging](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_network_policy.allow_prometheus_scraping](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_resource_quota.namespace_quota](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/resource_quota) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dependence_prometheus"></a> [dependence\_prometheus](#input\_dependence\_prometheus) | Prometheus module dependence - it is required in order to use this module. | `any` | n/a | yes |
| <a name="input_elasticsearch_audit_host"></a> [elasticsearch\_audit\_host](#input\_elasticsearch\_audit\_host) | The elasticsearch audit host where logs are going to be shipped | `any` | n/a | yes |
| <a name="input_elasticsearch_host"></a> [elasticsearch\_host](#input\_elasticsearch\_host) | The elasticsearch host where logs are going to be shipped | `any` | n/a | yes |
| <a name="input_enable_curator_cronjob"></a> [enable\_curator\_cronjob](#input\_enable\_curator\_cronjob) | Enable or not elastic-search curator cronjob - which runs every day to delete indices older than 30 days | `bool` | `false` | no |
| <a name="input_enable_fluent_bit"></a> [enable\_fluent\_bit](#input\_enable\_fluent\_bit) | Enable or not fluent-bit Helm Chart - change the default to true once it is ready to use | `bool` | `true` | no |

## Outputs

No outputs.

<!--- END_TF_DOCS --->

Reference:
https://github.com/fluent/helm-charts/tree/main/charts/fluent-bit


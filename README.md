# cloud-platform-terraform-logging

Terraform module that deploys cloud-platform logging solution. It includes components like: fluent-bit, eventrouter etc.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.6.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 2.1.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.12.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.6.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 2.1.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >=2.12.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.fluent_bit](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.prometheus_rule_alert](https://registry.terraform.io/providers/alekc/kubectl/2.1.3/docs/resources/manifest) | resource |
| [kubernetes_cluster_role.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_limit_range.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/limit_range) | resource |
| [kubernetes_namespace.logging](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_network_policy.allow_prometheus_scraping](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_resource_quota.namespace_quota](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/resource_quota) | resource |
| [kubernetes_service_account.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_elasticsearch_host"></a> [elasticsearch\_host](#input\_elasticsearch\_host) | The elasticsearch host where logs are going to be shipped | `any` | n/a | yes |
| <a name="input_enable_fluent_bit"></a> [enable\_fluent\_bit](#input\_enable\_fluent\_bit) | Enable or not fluent-bit Helm Chart - change the default to true once it is ready to use | `bool` | `true` | no |
| <a name="input_opensearch_app_host"></a> [opensearch\_app\_host](#input\_opensearch\_app\_host) | The opensearch host where user app logs are going to be shipped | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

Reference:
https://github.com/fluent/helm-charts/tree/main/charts/fluent-bit


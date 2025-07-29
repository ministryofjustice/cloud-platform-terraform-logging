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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.6.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 2.1.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >=2.12.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role"></a> [iam\_assumable\_role](#module\_iam\_assumable\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.59.0 |
| <a name="module_s3_bucket_application_logs"></a> [s3\_bucket\_application\_logs](#module\_s3\_bucket\_application\_logs) | github.com/ministryofjustice/cloud-platform-terraform-s3-bucket | 5.2.0 |

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
| [kubernetes_secret.s3_bucket_application_logs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service_account.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name | `string` | `""` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Area of the MOJ responsible for the service | `string` | `""` | no |
| <a name="input_elasticsearch_host"></a> [elasticsearch\_host](#input\_elasticsearch\_host) | The elasticsearch host where logs are going to be shipped | `any` | n/a | yes |
| <a name="input_enable_fluent_bit"></a> [enable\_fluent\_bit](#input\_enable\_fluent\_bit) | Enable or not fluent-bit Helm Chart - change the default to true once it is ready to use | `bool` | `true` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Environment name | `string` | `""` | no |
| <a name="input_infrastructure_support"></a> [infrastructure\_support](#input\_infrastructure\_support) | The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>) | `string` | `""` | no |
| <a name="input_is_production"></a> [is\_production](#input\_is\_production) | Whether this is used for production or not | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name | `string` | `"logging"` | no |
| <a name="input_opensearch_app_host"></a> [opensearch\_app\_host](#input\_opensearch\_app\_host) | The opensearch host where user app logs are going to be shipped | `any` | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Team name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fluent_bit_irsa_arn"></a> [fluent\_bit\_irsa\_arn](#output\_fluent\_bit\_irsa\_arn) | IAM Role ARN for Fluent Bit IRSA |
| <a name="output_s3_bucket_application_logs_arn"></a> [s3\_bucket\_application\_logs\_arn](#output\_s3\_bucket\_application\_logs\_arn) | S3 bucket ARN for application logs |
| <a name="output_s3_bucket_application_logs_name"></a> [s3\_bucket\_application\_logs\_name](#output\_s3\_bucket\_application\_logs\_name) | S3 bucket name for application logs |
<!-- END_TF_DOCS -->

Reference:
https://github.com/fluent/helm-charts/tree/main/charts/fluent-bit


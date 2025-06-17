module "test_firehose_eks_app_logs_to_xsiam" {
  source                    = "github.com/ministryofjustice/cloud-platform-terraform-firehose-data-stream?ref=fluentbit"
  destination_http_endpoint = var.cortex_xsiam_endpoint_preprod
}

###########################
# Get account information #
###########################
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

###################
# Get EKS cluster #
###################
data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
}

#########################
# Create assumable role #
#########################
module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  allow_self_assume_role     = false
  assume_role_condition_test = "StringEquals"
  create_role                = true
  force_detach_policies      = true
  role_name                  = "cloud-platform-firehose-fluentbit-irsa-${data.aws_eks_cluster.eks_cluster.name}"
  role_policy_arns           = module.test_firehose_eks_app_logs_to_xsiam.output.iam_role_arns[eks-to-firehose]
  oidc_providers = {
    (data.aws_eks_cluster.eks_cluster.name) : {
      provider_arn               = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}"
      namespace_service_accounts = ["logging:fluent-bit-cp-managed"]
    }
  }

  tags = default_tags
}
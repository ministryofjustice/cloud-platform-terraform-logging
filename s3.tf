####################
# Create S3 Bucket #
####################

module "s3_bucket_application_logs" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-s3-bucket?ref=5.2.0"

lifecycle_rule = [
    {
      enabled = true
      id      = "retire logs after 1 day"

      expiration = [
        {
          days = 1
        }
      ]
    }
  ]

  team_name              = var.team_name
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  environment_name       = var.environment_name
  infrastructure_support = var.infrastructure_support
  namespace              = var.namespace
}

resource "kubernetes_secret" "s3_bucket_application_logs" {
  metadata {
    name      = "s3-bucket-application-logs-output"
    namespace = var.namespace
  }

  data = {
    bucket_arn  = module.s3_bucket_application_logs.bucket_arn
    bucket_name = module.s3_bucket_application_logs.bucket_name
  }
}

###########################################
# Create IRSA for fluent-bit to access S3 #
###########################################

# Get account information #
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

# Get EKS cluster #
data "aws_eks_cluster" "eks_cluster" {
  name = terraform.workspace
}

# Create assumable role #
module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  allow_self_assume_role     = false
  assume_role_condition_test = "StringEquals"
  create_role                = true
  force_detach_policies      = true
  role_name                  = "cloud-platform-fluentbit-irsa-${data.aws_eks_cluster.eks_cluster.name}"
  role_policy_arns           = {
    s3 = module.s3_bucket_application_logs.irsa_policy_arn
  }
  oidc_providers = {
    (data.aws_eks_cluster.eks_cluster.name) : {
      provider_arn               = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}"
      namespace_service_accounts = ["logging:fluent-bit-cp-managed"]
    }
  }
}    
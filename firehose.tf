##########################################################################
# This provisions the infrastructure to push logs to Cortex XSIAM.       #
# The logs flow is fluent-bit -> CloudWatch -> Firehose -> Cortex XSIAM. # 
##########################################################################


###################
# Create Firehose #
###################
module "test_firehose_eks_app_logs_to_xsiam" {
  source                      = "github.com/ministryofjustice/cloud-platform-terraform-firehose-data-stream?ref=fluentbit"
  cloudwatch_log_group_names  = [aws_cloudwatch_log_group.application_logs.name]
  destination_http_endpoint   = var.cortex_xsiam_endpoint_preprod
}

###############################
# Create CloudWatch Log Group #
###############################
resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/cloud-platform/eks/${data.aws_eks_cluster.eks_cluster.name}/application-logs"
  retention_in_days = 14
}

###########################
# Create IRSA for fluent-bit to access CloudWatch #
###########################

# Get account information #
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

# Get EKS cluster #
data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
}

# Data block for IAM policy #
data "aws_iam_policy_document" "irsa-role-policy" {
  version = "2012-10-17"

  statement {
    sid    = "EKStoCloudWatch"
    effect = "Allow"
    actions = [
			"logs:CreateLogStream",
			"logs:CreateLogGroup",
			"logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.application_logs.arn,
      "${aws_cloudwatch_log_group.application_logs.arn}:*"
    ]
  }
}

# Create IAM policy #
resource "aws_iam_policy" "eks-to-cloudwatch" {
  name_prefix = "eks-to-cloudwatch"
  policy      = data.aws_iam_policy_document.irsa-role-policy.json
}

# Create assumable role #
module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  allow_self_assume_role     = false
  assume_role_condition_test = "StringEquals"
  create_role                = true
  force_detach_policies      = true
  role_name                  = "cloud-platform-firehose-fluentbit-irsa-${data.aws_eks_cluster.eks_cluster.name}"
  role_policy_arns           = {
    cloudwatch = aws_iam_policy.eks-to-cloudwatch.arn
  }
  oidc_providers = {
    (data.aws_eks_cluster.eks_cluster.name) : {
      provider_arn               = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}"
      namespace_service_accounts = ["logging:fluent-bit-cp-managed"]
    }
  }
}
module "test_firehose_eks_app_logs_to_xsiam" {
  source                    = "github.com/ministryofjustice/cloud-platform-terraform-firehose-data-stream?ref=fluentbit"
  destination_http_endpoint = var.cortex_xsiam_endpoint_preprod
}
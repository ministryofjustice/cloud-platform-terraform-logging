output "s3_bucket_application_logs_name" {
  description = "S3 bucket name for application logs"
  value       = module.s3_bucket_application_logs.bucket_name
}

output "s3_bucket_application_logs_arn" {
  description = "S3 bucket ARN for application logs"
  value       = module.s3_bucket_application_logs.bucket_arn
}

output "fluent_bit_irsa_arn" {
  description = "IAM Role ARN for Fluent Bit IRSA"
  value       = module.iam_assumable_role.iam_role_arn
}
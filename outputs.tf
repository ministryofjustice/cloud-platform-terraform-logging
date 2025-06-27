output "s3_bucket_application_logs_name" {
  description = "S3 bucket name for application logs"
  value       = module.s3_bucket_application_logs.bucket_name
}

output "s3_bucket_application_logs_arn" {
  description = "S3 bucket ARN for application logs"
  value       = module.s3_bucket_application_logs.bucket_arn
}
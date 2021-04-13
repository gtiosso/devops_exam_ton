## S3 BACKEND OUTPUT ##
output "s3_bucket_id" {
  value       = "${module.s3-backend.s3_bucket_id}"
  description = "The name of the bucket"
}

output "s3_bucket_arn" {
  value       = "${module.s3-backend.s3_bucket_arn}"
  description = "The ARN of the bucket"
}

output "s3_bucket_domain_name" {
  value       = "${module.s3-backend.s3_bucket_domain_name}"
  description = "The bucket domain name"
}

output "s3_bucket_regional_domain_name" {
  value       = "${module.s3-backend.s3_bucket_regional_domain_name}"
  description = "The bucket region-specific domain name"
}

output "s3_bucket_hosted_zone_id" {
  value       = "${module.s3-backend.s3_bucket_hosted_zone_id}"
  description = "The Route 53 Hosted Zone ID for this bucket's region"
}

output "s3_bucket_website_endpoint" {
  value       = "${module.s3-backend.s3_bucket_website_endpoint}"
  description = "The website endpoint, if the bucket is configured with a website"
}

output "s3_bucket_website_domain" {
  value       = "${module.s3-backend.s3_bucket_website_domain}"
  description = "The domain of the website endpoint, if the bucket is configured with a website"
}

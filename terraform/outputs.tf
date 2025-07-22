output "rds_primary_arn" {
  value       = module.rds.db_instance_arn
  description = "Primary RDS ARN (for use in replica setup)"
  condition   = module.rds != null
}

output "cloudfront_eu" {
  value = module.cloudfront.cloudfront_domain_name
}

output "cloudfront_sg" {
  value = module.cloudfront.cloudfront_domain_name
}

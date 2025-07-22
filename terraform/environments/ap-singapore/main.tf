provider "aws" {
  region = "ap-southeast-1"
}

module "vpc" {
  source   = "../../modules/vpc"
  name     = "wp-sg"
  region   = "ap-southeast-1"
}

module "alb_asg" {
  source       = "../../modules/alb-asg"
  name         = "wp-sg"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids
  sg_id        = module.vpc.wp_sg_id
  key_name     = var.key_name
  instance_type = "t2.micro"
  user_data_vars = {
    efs_dns         = module.efs.efs_dns
    rds_endpoint    = module.rds_replica.replica_endpoint
    s3_bucket       = module.s3.bucket
    db_name         = var.db_name
    db_user         = var.db_user
    db_password     = var.db_password
  }
}

module "efs" {
  source     = "../../modules/efs"
  name       = "wp-sg"
  subnet_ids = module.vpc.public_subnet_ids
  sg_id      = module.vpc.wp_sg_id
}

module "rds_replica" {
  source         = "../../modules/rds"
  name           = "wp-sg"
  db_username    = var.db_user
  db_password    = var.db_password
  subnet_ids     = module.vpc.public_subnet_ids
  sg_id          = module.vpc.wp_sg_id
  create_replica = true
  source_db_arn  = var.rds_primary_arn  # Should be passed from Ireland deployment
}

module "s3" {
  source = "../../modules/s3"
  name   = "wp-sg"
}

module "cloudfront" {
  source            = "../../modules/cloudfront-waf"
  name              = "wp-sg"
  alb_dns_name      = module.alb_asg.alb_dns_name
  blocked_countries = var.blocked_countries
}

output "cloudfront_domain_sg" {
  value = module.cloudfront.cloudfront_domain_name
}

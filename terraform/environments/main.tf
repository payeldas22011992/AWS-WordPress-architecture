provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source   = "../../modules/vpc"
  name     = "wp-eu"
  region   = "eu-west-1"
}

module "alb_asg" {
  source       = "../../modules/alb-asg"
  name         = "wp-eu"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids
  sg_id        = module.vpc.wp_sg_id
  key_name     = var.key_name
  instance_type = "t2.micro"
  user_data_vars = {
    efs_dns         = module.efs.efs_dns
    rds_endpoint    = module.rds.endpoint
    s3_bucket       = module.s3.bucket
    db_name         = var.db_name
    db_user         = var.db_user
    db_password     = var.db_password
  }
}

module "efs" {
  source     = "../../modules/efs"
  name       = "wp-eu"
  subnet_ids = module.vpc.public_subnet_ids
  sg_id      = module.vpc.wp_sg_id
}

module "rds" {
  source         = "../../modules/rds"
  name           = "wp-eu"
  db_username    = var.db_user
  db_password    = var.db_password
  subnet_ids     = module.vpc.public_subnet_ids
  sg_id          = module.vpc.wp_sg_id
  create_replica = false
}

module "s3" {
  source = "../../modules/s3"
  name   = "wp-eu"
}

module "cloudfront" {
  source            = "../../modules/cloudfront-waf"
  name              = "wp-eu"
  alb_dns_name      = module.alb_asg.alb_dns_name
  blocked_countries = var.blocked_countries
}

output "cloudfront_domain_eu" {
  value = module.cloudfront.cloudfront_domain_name
}

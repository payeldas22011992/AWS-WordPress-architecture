provider "aws" {
  region = "ap-southeast-1"
}

module "vpc" {
  source = "../../modules/vpc"
  region = "ap-southeast-1"
  vpc_name = "wordpress-apac-vpc"
}

module "ec2" {
  source = "../../modules/ec2-wordpress"
  region = "ap-southeast-1"
  subnet_id = module.vpc.public_subnet_ids[0]
  sg_id = module.vpc.wp_sg_id
  instance_name = "wp-sg-instance"
}

module "alb_asg" {
  source = "../../modules/alb-asg"

  name         = "wp-eu" # or wp-sg for singapore
  key_name     = var.key_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids
  sg_id        = module.vpc.wp_sg_id
}

module "cloudfront" {
  source = "../../modules/cloudfront-waf"

  name            = "wp-eu"
  alb_dns_name    = module.alb_asg.alb_dns_name
  blocked_countries = ["RU", "KP", "IR"]
}

module "rds_replica" {
  source         = "../../modules/rds"
  name           = "wp-sg"
  db_username    = "admin"
  db_password    = "Admin12345"
  subnet_ids     = module.vpc.public_subnet_ids
  sg_id          = module.vpc.wp_sg_id
  create_replica = true
  source_db_arn  = "arn:aws:rds:eu-west-1:123456789012:db:wp-eu-primary" # Replace dynamically
}

module "efs" {
  source     = "../../modules/efs"
  name       = "wp-sg"
  subnet_ids = module.vpc.public_subnet_ids
  sg_id      = module.vpc.wp_sg_id
}


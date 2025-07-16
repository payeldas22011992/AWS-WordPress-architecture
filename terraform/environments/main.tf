module "vpc" {
  source              = "../../modules/vpc"
  providers           = { aws = aws.primary }
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  azs                 = ["eu-west-1a", "eu-west-1b"]
  project_name        = var.project_name
}
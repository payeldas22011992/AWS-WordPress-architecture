module "vpc" {
  source              = "../../modules/vpc"
  providers           = { aws = aws.secondary }
  vpc_cidr            = "10.1.0.0/16"
  public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
  azs                 = ["ap-southeast-1a", "ap-southeast-1b"]
  project_name        = var.project_name
}


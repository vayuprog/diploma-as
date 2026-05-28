provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "juice-shop-security-lab"
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name         = var.name
  cluster_name = var.cluster_name
  region       = var.region
  azs          = var.azs
}

module "security" {
  source = "../../modules/security"

  name     = var.name
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
  region   = var.region
}

module "eks" {
  source = "../../modules/eks"

  name               = var.name
  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  node_sg_id         = module.security.node_sg_id
  allowed_cidr       = var.allowed_cidr
  region             = var.region
}

module "ecr" {
  source = "../../modules/ecr"

  name = "juice-shop"
}

module "waf" {
  source = "../../modules/waf"

  name   = var.name
  region = var.region
}

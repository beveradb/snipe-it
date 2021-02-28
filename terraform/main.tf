terraform {
  backend "s3" {
    bucket = "beveradb-personal-terraform-state"
    key    = "terraform-bimtwin.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

module "vpc" {
  source         = "./modules/vpc"
  tags           = var.tags
  region         = var.region
  project_name   = var.project_name
  primary_domain = var.primary_domain
}

module "ec2" {
  source     = "./modules/ec2"
  depends_on = [module.vpc]

  tags               = var.tags
  region             = var.region
  project_name       = var.project_name
  domain             = var.primary_domain
  ec2_ssh_key_name   = var.ec2_ssh_key_name
  ec2_ssh_public_key = var.ec2_ssh_public_key

  vpc_id             = module.vpc.vpc_id
  route53_zone_id    = module.vpc.route53_zone_id
  acm_cert_arn       = module.vpc.acm_cert_arn
  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = module.vpc.security_group_ids
}

module "rds" {
  source     = "./modules/rds"
  depends_on = [module.vpc, module.ec2]

  tags         = var.tags
  db_name      = var.db_name
  project_name = var.project_name

  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = module.vpc.security_group_ids
}

module "ecs" {
  source     = "./modules/ecs"
  depends_on = [module.vpc, module.ec2, module.rds]

  tags         = var.tags
  project_name = var.project_name
  domain       = var.primary_domain
  region       = var.region

  vpc_id             = module.vpc.vpc_id
  route53_zone_id    = module.vpc.route53_zone_id
  acm_cert_arn       = module.vpc.acm_cert_arn
  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = module.vpc.security_group_ids

}

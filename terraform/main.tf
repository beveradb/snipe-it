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
  source                  = "./modules/vpc"
  tags                    = var.tags
  region                  = var.region
  project_name_hyphenated = var.project_name_hyphenated
  primary_domain          = var.primary_domain
}

module "rds" {
  source     = "./modules/rds"
  depends_on = [module.vpc]

  tags                    = var.tags
  db_name                 = var.db_name
  project_name_hyphenated = var.project_name_hyphenated

  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = module.vpc.security_group_ids
}

module "ses" {
  source     = "./modules/ses"
  depends_on = [module.vpc]

  tags                    = var.tags
  region                  = var.region
  project_name_hyphenated = var.project_name_hyphenated
  domain                  = var.primary_domain
  ses_bucket_name         = "${var.primary_domain}-ses-email-inbox"
  route53_zone_id         = module.vpc.route53_zone_id
}

module "efs" {
  source     = "./modules/efs"
  depends_on = [module.vpc]

  tags                    = var.tags
  region                  = var.region
  domain                  = var.primary_domain
  project_name_hyphenated = var.project_name_hyphenated
  subnet_ids              = module.vpc.subnet_ids
}

module "ecs" {
  source     = "./modules/ecs"
  depends_on = [module.vpc, module.rds, module.ses]

  tags                    = var.tags
  project_name_hyphenated = var.project_name_hyphenated
  domain                  = var.primary_domain
  region                  = var.region
  docker_image            = var.docker_image
  container_port          = var.container_port

  container_health_check_grace_period_seconds = 180
  container_env_vars_config                   = <<EOF
      "environment" : [
          { "name" : "APP_DEBUG", "value" : "false" },
          { "name" : "PGID", "value" : "1000" },
          { "name" : "PUID", "value" : "1000" },
          { "name" : "MAIL_ENV_ENCRYPTION", "value" : "tls" },
          { "name" : "MAIL_PORT_587_TCP_PORT", "value" : "587" },
          { "name" : "MAIL_ENV_FROM_ADDR", "value" : "${var.admin_email}" },
          { "name" : "MAIL_ENV_FROM_NAME", "value" : "${var.project_name_proper_case}" },
          { "name" : "MAIL_PORT_587_TCP_ADDR", "value" : "${module.ses.smtp_server}" },
          { "name" : "MAIL_ENV_USERNAME", "value" : "${module.ses.smtp_username}" },
          { "name" : "MAIL_ENV_PASSWORD", "value" : "${module.ses.smtp_password_v4}" },
          { "name" : "MYSQL_PORT_3306_TCP_PORT", "value" : "3306" },
          { "name" : "MYSQL_DATABASE", "value" : "${var.db_name}" },
          { "name" : "MYSQL_PORT_3306_TCP_ADDR", "value" : "${module.rds.db_endpoint}" },
          { "name" : "MYSQL_USER", "value" : "${module.rds.db_username}" },
          { "name" : "MYSQL_PASSWORD", "value" : "${module.rds.db_password}" },
          { "name" : "APP_URL", "value" : "https://ecs.${var.primary_domain}" }
      ],
EOF

  vpc_id             = module.vpc.vpc_id
  route53_zone_id    = module.vpc.route53_zone_id
  acm_cert_arn       = module.vpc.acm_cert_arn
  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = module.vpc.security_group_ids
}

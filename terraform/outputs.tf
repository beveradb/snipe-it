output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}
output "db_username" {
  value = module.rds.db_username
}
output "db_password" {
  value = module.rds.db_password
}
output "db_port" {
  value = module.rds.db_port
}

output "ecs_alb_dns_addr" {
  value = module.ecs.ecs_alb_dns_addr
}

output "ecs_subdomain_url" {
  value = module.ecs.ecs_subdomain_url
}

output "smtp_server" {
  value = module.ses.smtp_server
}

output "smtp_username" {
  value = module.ses.smtp_username
}

output "smtp_password_v4" {
  value = module.ses.smtp_password_v4
}

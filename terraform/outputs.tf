output "vpc_id" {
  value = module.vpc.vpc_id
}

output "bastion_eip_dns_addr" {
  value = module.ec2.bastion_alb_dns_addr
}

output "bastion_subdomain_url" {
  value = module.ec2.bastion_subdomain_url
}

output "bastion_alb_dns_addr" {
  value = module.ec2.bastion_alb_dns_addr
}

output "bastion_lb_subdomain_url" {
  value = module.ec2.bastion_lb_subdomain_url
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

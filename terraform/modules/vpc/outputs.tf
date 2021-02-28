output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "route53_zone_id" {
  value = data.aws_route53_zone.route53-zone.id
}

output "security_group_ids" {
  value = {
    egress-all    = aws_security_group.egress-all.id
    ingress-http  = aws_security_group.http.id
    ingress-https = aws_security_group.https.id
    ingress-ssh   = aws_security_group.ssh.id
    ingress-api   = aws_security_group.api-ingress.id
    ingress-mysql = aws_security_group.mysql-ingress.id
  }
}

output "acm_cert_arn" {
  value = aws_acm_certificate.acm-cert.arn
}

output "subnet_ids" {
  value = {
    ec2-subnet-one        = aws_subnet.ec2-subnet-one.id
    ec2-subnet-two        = aws_subnet.ec2-subnet-two.id
    rds-subnet-one        = aws_subnet.rds-subnet-one.id
    rds-subnet-two        = aws_subnet.rds-subnet-two.id
    ecs-subnet-private    = aws_subnet.ecs-subnet-private.id
    ecs-subnet-public-one = aws_subnet.ecs-subnet-public-one.id
    ecs-subnet-public-two = aws_subnet.ecs-subnet-public-two.id
  }
}

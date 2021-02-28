resource "aws_alb" "bimtwin-snipe-bastion-alb" {
  name               = "bimtwin-snipe-bastion-alb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.bimtwin-snipe-bastion-subnet.id,
    aws_subnet.bimtwin-snipe-bastion-subnet-two.id
  ]

  security_groups = [
    aws_security_group.bimtwin-snipe-bastion-ingress.id
  ]

  depends_on = [aws_internet_gateway.bimtwin-snipe-igw]
  tags       = local.tags
}

resource "aws_lb_target_group" "bimtwin-snipe-bastion-alb-tg" {
  name        = "bimtwin-snipe-bastion-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.bimtwin-snipe-vpc.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.bimtwin-snipe-bastion-alb]
  tags       = local.tags
}

resource "aws_lb_target_group_attachment" "bimtwin-snipe-bastion-alb-tg-attach" {
  target_group_arn = aws_lb_target_group.bimtwin-snipe-bastion-alb-tg.arn
  target_id        = aws_instance.bimtwin-snipe-bastion-instance.id
  port             = 80

  depends_on = [aws_lb_target_group.bimtwin-snipe-bastion-alb-tg]
}

resource "aws_alb_listener" "bimtwin-snipe-bastion-alb-http" {
  load_balancer_arn = aws_alb.bimtwin-snipe-bastion-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bimtwin-snipe-bastion-alb-tg.arn
  }
}

resource "aws_alb_listener" "bimtwin-snipe-bastion-alb-https" {
  load_balancer_arn = aws_alb.bimtwin-snipe-bastion-alb.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bimtwin-snipe-bastion-alb-tg.arn
  }

  certificate_arn = aws_acm_certificate_validation.bimtwin-acm-cert-validation.certificate_arn
}

resource "aws_route53_record" "bimtwin-snipe-bastion-lb-dns" {
  zone_id = data.aws_route53_zone.bimtwin-route53-zone.id
  name    = "bastionlb.bimtwin.ml"
  type    = "CNAME"
  ttl     = "5"
  records = [aws_alb.bimtwin-snipe-bastion-alb.dns_name]
}

output "bimtwin-snipe-bastion-alb-url" {
  value = "http://${aws_alb.bimtwin-snipe-bastion-alb.dns_name}"
}

output "bimtwin-snipe-bastion-lb-dns-url" {
  value = "http://bastionlb.bimtwin.ml"
}
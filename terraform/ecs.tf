//locals {
//  repository_url = "beveradb/sun-api"
//}
//
//# We need a cluster in which to put our service.
//resource "aws_ecs_cluster" "bimtwin-snipe-ecs-cluster" {
//  name = "bimtwin-snipe"
//}
//
//# An ECR repository is a private alternative to Docker Hub.
//resource "aws_ecr_repository" "bimtwin-snipe-ecr" {
//  name = "bimtwin-snipe-ecr"
//}
//
//# Log groups hold logs from our app.
//resource "aws_cloudwatch_log_group" "bimtwin-snipe-log-group" {
//  name = "/ecs/bimtwin-snipe"
//}
//
//# The main service.
//resource "aws_ecs_service" "bimtwin-snipe-ecs-service" {
//  name            = "bimtwin-snipe-ecs-service"
//  task_definition = aws_ecs_task_definition.bimtwin-snipe-ecs-task.arn
//  cluster         = aws_ecs_cluster.bimtwin-snipe-ecs-cluster.id
//  launch_type     = "FARGATE"
//
//  desired_count = 1
//
//  load_balancer {
//    target_group_arn = aws_lb_target_group.bimtwin-snipe-ecs-alb-tg.arn
//    container_name   = "bimtwin-snipe"
//    container_port   = "3000"
//  }
//
//  network_configuration {
//    assign_public_ip = false
//
//    security_groups = [
//      aws_security_group.bimtwin-snipe-egress-all.id,
//      aws_security_group.bimtwin-snipe-api-ingress.id,
//    ]
//
//    subnets = [
//      aws_subnet.bimtwin-snipe-ecs-subnet-private.id,
//    ]
//  }
//
//  depends_on = [
//    aws_alb.bimtwin-snipe-ecs-alb,
//    aws_lb_target_group.bimtwin-snipe-ecs-alb-tg
//  ]
//}
//
//# The task definition for our app.
//resource "aws_ecs_task_definition" "bimtwin-snipe-ecs-task" {
//  family = "bimtwin-snipe"
//
//  container_definitions = <<EOF
//  [
//    {
//      "name": "bimtwin-snipe",
//      "image": "${local.repository_url == "" ? aws_ecr_repository.bimtwin-snipe-ecr.repository_url : local.repository_url}:latest",
//      "portMappings": [
//        {
//          "containerPort": 3000
//        }
//      ],
//      "logConfiguration": {
//        "logDriver": "awslogs",
//        "options": {
//          "awslogs-region": "eu-west-1",
//          "awslogs-group": "/ecs/bimtwin-snipe",
//          "awslogs-stream-prefix": "ecs"
//        }
//      }
//    }
//  ]
//
//EOF
//
//  execution_role_arn = aws_iam_role.bimtwin-snipe-ecs-task-execution-role.arn
//
//  # These are the minimum values for Fargate containers.
//  cpu                      = 256
//  memory                   = 512
//  requires_compatibilities = ["FARGATE"]
//
//  # This is required for Fargate containers (more on this later).
//  network_mode = "awsvpc"
//}
//
//# This is the role under which ECS will execute our task. This role becomes more important
//# as we add integrations with other AWS services later on.
//
//# The assume_role_policy field works with the following aws_iam_policy_document to allow
//# ECS tasks to assume this role we're creating.
//resource "aws_iam_role" "bimtwin-snipe-ecs-task-execution-role" {
//  name               = "bimtwin-snipe-ecs-task-execution-role"
//  assume_role_policy = data.aws_iam_policy_document.ecs-task-assume-role.json
//}
//
//data "aws_iam_policy_document" "ecs-task-assume-role" {
//  statement {
//    actions = ["sts:AssumeRole"]
//
//    principals {
//      type        = "Service"
//      identifiers = ["ecs-tasks.amazonaws.com"]
//    }
//  }
//}
//
//# Normally we'd prefer not to hardcode an ARN in our Terraform, but since this is an AWS-managed
//# policy, it's okay.
//data "aws_iam_policy" "ecs-task-execution-role" {
//  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
//}
//
//# Attach the above policy to the execution role.
//resource "aws_iam_role_policy_attachment" "ecs-task-execution-role" {
//  role       = aws_iam_role.bimtwin-snipe-ecs-task-execution-role.name
//  policy_arn = data.aws_iam_policy.ecs-task-execution-role.arn
//}
//
//resource "aws_lb_target_group" "bimtwin-snipe-ecs-alb-tg" {
//  name        = "bimtwin-snipe-ecs-alb-tg"
//  port        = 3000
//  protocol    = "HTTP"
//  target_type = "ip"
//  vpc_id      = aws_vpc.bimtwin-snipe-vpc.id
//
//  health_check {
//    enabled = true
//    path    = "/health"
//  }
//
//  depends_on = [aws_alb.bimtwin-snipe-ecs-alb]
//}
//
//resource "aws_alb" "bimtwin-snipe-ecs-alb" {
//  name               = "bimtwin-snipe-ecs-alb"
//  internal           = false
//  load_balancer_type = "application"
//
//  subnets = [
//    aws_subnet.bimtwin-snipe-ecs-subnet-public.id,
//    aws_subnet.bimtwin-snipe-ecs-subnet-private.id,
//  ]
//
//  security_groups = [
//    aws_security_group.bimtwin-snipe-http.id,
//    aws_security_group.bimtwin-snipe-https.id,
//    aws_security_group.bimtwin-snipe-egress-all.id,
//  ]
//
//  depends_on = [aws_internet_gateway.bimtwin-snipe-igw]
//}
//
//resource "aws_alb_listener" "bimtwin-snipe-ecs-alb-listener-http" {
//  load_balancer_arn = aws_alb.bimtwin-snipe-ecs-alb.arn
//  port              = "80"
//  protocol          = "HTTP"
//
//  default_action {
//    type = "redirect"
//
//    redirect {
//      port        = "443"
//      protocol    = "HTTPS"
//      status_code = "HTTP_301"
//    }
//  }
//}
//
//resource "aws_alb_listener" "bimtwin-snipe-ecs-alb-listener-https" {
//  load_balancer_arn = aws_alb.bimtwin-snipe-ecs-alb.arn
//  port              = "443"
//  protocol          = "HTTPS"
//  certificate_arn   = aws_acm_certificate.bimtwin-acm-cert.arn
//
//  default_action {
//    type             = "forward"
//    target_group_arn = aws_lb_target_group.bimtwin-snipe-ecs-alb-tg.arn
//  }
//}
//
//output "bimtwin-snipe-ecs-alb-url" {
//  value = "http://${aws_alb.bimtwin-snipe-ecs-alb.dns_name}"
//}
//
//resource "aws_route53_record" "bimtwin-snipe-ecs-lb-primary-dns" {
//  zone_id = data.aws_route53_zone.bimtwin-route53-zone.id
//  name    = "bimtwin.ml"
//  type    = "CNAME"
//  ttl     = "5"
//  records = [aws_alb.bimtwin-snipe-ecs-alb.dns_name]
//}
//
//resource "aws_route53_record" "bimtwin-snipe-ecs-lb-subdomain-dns" {
//  zone_id = data.aws_route53_zone.bimtwin-route53-zone.id
//  name    = "ecs.bimtwin.ml"
//  type    = "CNAME"
//  ttl     = "5"
//  records = [aws_alb.bimtwin-snipe-ecs-alb.dns_name]
//}
//
//output "bimtwin-snipe-url" {
//  value = "https://bimtwin.ml"
//}
//output "bimtwin-snipe-url-two" {
//  value = "https://ecs.bimtwin.ml"
//}
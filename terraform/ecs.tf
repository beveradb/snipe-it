///*
// * Create public and private subnets for each availability zone
// */
//resource "aws_subnet" "bimtwin-snipe-ecs-public-subnet" {
//  count             = length(local.aws_zones)
//  vpc_id            = aws_vpc.bimtwin-snipe-vpc.id
//  availability_zone = element(local.aws_zones, count.index)
//  cidr_block        = "10.0.${(count.index + 1) * 10}.0/24"
//  tags              = local.tags
//}
//resource "aws_subnet" "bimtwin-snipe-ecs-private-subnet" {
//  count             = length(local.aws_zones)
//  vpc_id            = aws_vpc.bimtwin-snipe-vpc.id
//  availability_zone = element(local.aws_zones, count.index)
//  cidr_block        = "10.0.${(count.index + 1) * 11}.0/24"
//  tags              = local.tags
//}
//
//resource "aws_ecs_cluster" "bimtwin-snipe-ecs-cluster" {
//  name = "bimtwin-snipe-ecs-cluster"
//
//  capacity_providers = ["FARGATE_SPOT", "FARGATE"]
//
//  default_capacity_provider_strategy {
//    capacity_provider = "FARGATE_SPOT"
//  }
//
//  setting {
//    name  = "containerInsights"
//    value = "disabled"
//  }
//}
//
//module "bimtwin-snipe-ecs-fargate" {
//  source  = "umotif-public/ecs-fargate/aws"
//  version = "~> 6.0.0"
//
//  name_prefix        = "bimtwin-snipe-ecs-fargate"
//  vpc_id             = aws_vpc.bimtwin-snipe-vpc.id
//  private_subnet_ids = [aws_subnet.bimtwin-snipe-ecs-private-subnet[0].id, aws_subnet.bimtwin-snipe-ecs-private-subnet[1].id]
//
//  cluster_id = aws_ecs_cluster.bimtwin-snipe-ecs-cluster.id
//
//  task_container_image   = "marcincuber/2048-game:latest"
//  task_definition_cpu    = 256
//  task_definition_memory = 512
//
//  task_container_port             = 80
//  task_container_assign_public_ip = true
//
//  target_groups = [
//    {
//      target_group_name = "bimtwin-snipe-ecs-target-group"
//      container_port    = 80
//    }
//  ]
//
//  health_check = {
//    port = "traffic-port"
//    path = "/"
//  }
//
//  tags = local.tags
//}

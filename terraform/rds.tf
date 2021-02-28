
resource "aws_db_subnet_group" "bimtwin-snipe-db-subnet-group" {
  name       = "${local.name}-subnet-group"
  subnet_ids = [aws_subnet.bimtwin-snipe-db-subnet-one.id, aws_subnet.bimtwin-snipe-db-subnet-two.id]

  tags = local.tags
}

resource "aws_rds_cluster" "bimtwin-snipe-db-cluster" {
  cluster_identifier     = "bimtwin-snipe-db-cluster"
  engine                 = "aurora-mysql"
  engine_mode            = "serverless"
  engine_version         = "5.7.mysql_aurora.2.07.1"
  port                   = "3306"
  database_name          = local.db_name
  master_username        = local.db_username
  master_password        = local.db_password
  enable_http_endpoint   = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.bimtwin-snipe-db-subnet-group.name
  vpc_security_group_ids = [
    aws_security_group.bimtwin-snipe-egress-all.id,
    aws_security_group.bimtwin-snipe-http.id,
    aws_security_group.bimtwin-snipe-https.id,
    aws_security_group.bimtwin-snipe-mysql-ingress.id,
  ]
  scaling_configuration {
    min_capacity = 2
  }
}

output "bimtwin-snipe_db_endpoint" {
  value = aws_rds_cluster.bimtwin-snipe-db-cluster.endpoint
}
output "bimtwin-snipe_db_username" {
  value = aws_rds_cluster.bimtwin-snipe-db-cluster.master_username
}
output "bimtwin-snipe_db_password" {
  value = aws_rds_cluster.bimtwin-snipe-db-cluster.master_password
}
output "bimtwin-snipe_db_port" {
  value = aws_rds_cluster.bimtwin-snipe-db-cluster.port
}
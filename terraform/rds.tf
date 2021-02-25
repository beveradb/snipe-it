resource "aws_security_group" "bimtwin-snipe-db-ingress" {
  name        = "bimtwin-snipe-db-security-group"
  description = "Allow HTTP, HTTPS and MySQL traffic from anywhere"

  vpc_id = aws_vpc.bimtwin-snipe-vpc.id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_subnet" "bimtwin-snipe-db-subnet-one" {
  cidr_block        = cidrsubnet(aws_vpc.bimtwin-snipe-vpc.cidr_block, 3, 2)
  vpc_id            = aws_vpc.bimtwin-snipe-vpc.id
  availability_zone = "${local.region}a"
  tags              = local.tags
}

resource "aws_subnet" "bimtwin-snipe-db-subnet-two" {
  cidr_block        = cidrsubnet(aws_vpc.bimtwin-snipe-vpc.cidr_block, 3, 3)
  vpc_id            = aws_vpc.bimtwin-snipe-vpc.id
  availability_zone = "${local.region}b"
  tags              = local.tags
}

resource "aws_route_table_association" "bimtwin-snipe-db-subnet-one-route-table-association" {
  subnet_id      = aws_subnet.bimtwin-snipe-db-subnet-one.id
  route_table_id = aws_route_table.bimtwin-snipe-route-table.id
}

resource "aws_route_table_association" "bimtwin-snipe-db-subnet-two-route-table-association" {
  subnet_id      = aws_subnet.bimtwin-snipe-db-subnet-two.id
  route_table_id = aws_route_table.bimtwin-snipe-route-table.id
}

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
  vpc_security_group_ids = [aws_security_group.bimtwin-snipe-db-ingress.id]
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
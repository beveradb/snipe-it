# Define initial parameters and local values shared in the rest of the file
terraform {
  backend "s3" {
    bucket = "beveradb-personal-terraform-state"
    key    = "terraform-bimtwin.tfstate"
    region = "eu-west-2"
  }
}

locals {
  region = "eu-west-1"
  name   = "bimtwin-snipe"

  db_name     = "snipe"
  db_username = random_pet.random-pet.id
  db_password = random_password.random-password.result

  tags = {
    Name                   = "upwork-bimtwin-terraform"
    Terraform              = "true"
    AndrewFreelanceProject = "upwork-bimtwin"
  }
}

provider "aws" {
  profile = "default"
  region  = local.region
}

resource "random_pet" "random-pet" {
  length    = "2"
  separator = "_"
}

resource "random_password" "random-password" {
  length  = 20
  special = false
}

resource "aws_key_pair" "AndrewCurveMacBook2020RSA" {
  key_name   = "AndrewCurveMacBook2020RSA"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUtncWdrej/ddZQU9d6DHJQswqPXiFdwKu+3SqEjW+/j5S3QJ7bXY9qkOa4eh1QDluK6mljNCb4AWDaY6n2CS0tB2y2zY82caIaAHzjgjXwxl03izhw6tLhxiqvi0vZayejsy2uRtlB1vCF3gcZ+KBqAv43nE0H1wtlF+7riSdzNo6WRPoPIai+RusKSZmKm0dqqhkriQT3OIUecZipbNvBTp6h0NDsbEMGEEKqoh4PP0Lf7z7AiIo/8qXZDCJXgi8PnsASljl1Gk6LiBo17GbQlek91/RGAfqqTIL11aL4/zZ+GCBLNR43FdCrb9SVqANfB7uW56N3wu+erzcquzd andrewbeveridge@ip-10-15-233-210.eu-west-1.compute.internal"
}

resource "aws_vpc" "ubuntu-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = local.tags
}

resource "aws_subnet" "ubuntu-subnet" {
  cidr_block        = cidrsubnet(aws_vpc.ubuntu-vpc.cidr_block, 3, 1)
  vpc_id            = aws_vpc.ubuntu-vpc.id
  availability_zone = "${local.region}a"
  tags              = local.tags
}

resource "aws_internet_gateway" "ubuntu-igw" {
  vpc_id = aws_vpc.ubuntu-vpc.id
  tags   = local.tags
}

resource "aws_route_table" "ubuntu-route-table" {
  vpc_id = aws_vpc.ubuntu-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ubuntu-igw.id
  }
  tags   = local.tags
}

resource "aws_route_table_association" "ubuntu-route-table-subnet-association" {
  subnet_id      = aws_subnet.ubuntu-subnet.id
  route_table_id = aws_route_table.ubuntu-route-table.id
}

data "aws_ami" "ubuntu-ami" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-focal-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ubuntu-ingress" {
  name        = "ubuntu-security-group"
  description = "Allow HTTP, HTTPS and SSH traffic from anywhere"

  vpc_id = aws_vpc.ubuntu-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "ubuntu-instance" {
  key_name      = aws_key_pair.AndrewCurveMacBook2020RSA.key_name
  ami           = data.aws_ami.ubuntu-ami.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.ubuntu-subnet.id

  vpc_security_group_ids = [aws_security_group.ubuntu-ingress.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("key")
    host        = self.public_ip
  }

  tags = local.tags
}

resource "aws_eip" "ubuntu-eip" {
  vpc      = true
  instance = aws_instance.ubuntu-instance.id

  tags = local.tags
}


resource "aws_security_group" "snipe-db-ingress" {
  name        = "snipe-db-security-group"
  description = "Allow HTTP, HTTPS and MySQL traffic from anywhere"

  vpc_id = aws_vpc.ubuntu-vpc.id

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

resource "aws_subnet" "snipe-db-subnet-one" {
  cidr_block        = cidrsubnet(aws_vpc.ubuntu-vpc.cidr_block, 3, 2)
  vpc_id            = aws_vpc.ubuntu-vpc.id
  availability_zone = "${local.region}a"
  tags              = local.tags
}

resource "aws_subnet" "snipe-db-subnet-two" {
  cidr_block        = cidrsubnet(aws_vpc.ubuntu-vpc.cidr_block, 3, 3)
  vpc_id            = aws_vpc.ubuntu-vpc.id
  availability_zone = "${local.region}b"
  tags              = local.tags
}

resource "aws_route_table_association" "snipe-db-subnet-one-route-table-association" {
  subnet_id      = aws_subnet.snipe-db-subnet-one.id
  route_table_id = aws_route_table.ubuntu-route-table.id
}

resource "aws_route_table_association" "snipe-db-subnet-two-route-table-association" {
  subnet_id      = aws_subnet.snipe-db-subnet-two.id
  route_table_id = aws_route_table.ubuntu-route-table.id
}

resource "aws_db_subnet_group" "snipe-db-subnet-group" {
  name       = "${local.name}-subnet-group"
  subnet_ids = [aws_subnet.snipe-db-subnet-one.id, aws_subnet.snipe-db-subnet-two.id]

  tags = local.tags
}

resource "aws_rds_cluster" "snipe-db-cluster" {
  cluster_identifier     = "snipe-db-cluster"
  availability_zones     = ["${local.region}a", "${local.region}b", "${local.region}c"]
  engine                 = "aurora-mysql"
  engine_mode            = "serverless"
  engine_version         = "5.7.mysql_aurora.2.07.1"
  port                   = "3306"
  database_name          = local.db_name
  master_username        = local.db_username
  master_password        = local.db_password
  enable_http_endpoint   = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.snipe-db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.snipe-db-ingress.id]
  scaling_configuration {
    min_capacity = 2
  }
}

output "instance_eip_dns_addr" {
  value = aws_eip.ubuntu-eip.public_dns
}
output "snipe_db_endpoint" {
  value = aws_rds_cluster.snipe-db-cluster.endpoint
}
output "snipe_db_username" {
  value = aws_rds_cluster.snipe-db-cluster.master_username
}
output "snipe_db_password" {
  value = aws_rds_cluster.snipe-db-cluster.master_password
}
output "snipe_db_port" {
  value = aws_rds_cluster.snipe-db-cluster.port
}
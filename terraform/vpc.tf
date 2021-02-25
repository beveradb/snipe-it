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

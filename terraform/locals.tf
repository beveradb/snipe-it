locals {
  region = "eu-west-1"
  name   = "bimtwin-snipe"

  db_name     = "snipe"
  db_username = random_pet.random-pet.id
  db_password = random_password.random-password.result

  aws_zones       = ["eu-west-1a", "eu-west-1b"]

  tags = {
    Name                   = "upwork-bimtwin-terraform"
    Terraform              = "true"
    AndrewFreelanceProject = "upwork-bimtwin"
  }
}

data "aws_route53_zone" "bimtwin-route53-zone" {
  name         = "bimtwin.ml"
  private_zone = false
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
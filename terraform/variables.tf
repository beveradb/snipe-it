variable "region" {
  type    = string
  default = "eu-west-1"
}
variable "aws_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}
variable "project_name" {
  type    = string
  default = "bimtwin-snipe"
}
variable "primary_domain" {
  type    = string
  default = "bimtwin.ml"
}
variable "docker_image" {
  type    = string
  default = "linuxserver/snipe-it"
}
variable "docker_image_version" {
  type    = string
  default = "version-v5.0.12"
}
variable "container_port" {
  type    = number
  default = 80
}
variable "db_name" {
  type    = string
  default = "snipe"
}
variable "tags" {
  type    = map(string)
  default = {
    Name                   = "upwork-bimtwin-terraform"
    Terraform              = "true"
    AndrewFreelanceProject = "upwork-bimtwin"
  }
}
variable "ec2_ssh_key_name" {
  type    = string
  default = "AndrewCurveMacBook2020RSA"
}
variable "ec2_ssh_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUtncWdrej/ddZQU9d6DHJQswqPXiFdwKu+3SqEjW+/j5S3QJ7bXY9qkOa4eh1QDluK6mljNCb4AWDaY6n2CS0tB2y2zY82caIaAHzjgjXwxl03izhw6tLhxiqvi0vZayejsy2uRtlB1vCF3gcZ+KBqAv43nE0H1wtlF+7riSdzNo6WRPoPIai+RusKSZmKm0dqqhkriQT3OIUecZipbNvBTp6h0NDsbEMGEEKqoh4PP0Lf7z7AiIo/8qXZDCJXgi8PnsASljl1Gk6LiBo17GbQlek91/RGAfqqTIL11aL4/zZ+GCBLNR43FdCrb9SVqANfB7uW56N3wu+erzcquzd andrewbeveridge@ip-10-15-233-210.eu-west-1.compute.internal"
}

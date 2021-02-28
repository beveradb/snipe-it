resource "aws_vpc" "bimtwin-snipe-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = local.tags
}

/*
 * Get default security group for reference later
 */
data "aws_security_group" "bimtwin-snipe-vpc-default-sg" {
  name   = "default"
  vpc_id = aws_vpc.bimtwin-snipe-vpc.id
}

resource "aws_internet_gateway" "bimtwin-snipe-igw" {
  vpc_id = aws_vpc.bimtwin-snipe-vpc.id
  tags   = local.tags
}

resource "aws_route_table" "bimtwin-snipe-route-table" {
  vpc_id = aws_vpc.bimtwin-snipe-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bimtwin-snipe-igw.id
  }
  tags   = local.tags
}

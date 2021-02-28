data "aws_security_group" "bimtwin-snipe-vpc-default-sg" {
  name   = "default"
  vpc_id = aws_vpc.bimtwin-snipe-vpc.id
}

resource "aws_security_group" "bimtwin-snipe-egress-all" {
  name        = "bimtwin-snipe-egress-all"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.bimtwin-snipe-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

resource "aws_security_group" "bimtwin-snipe-http" {
  name        = "bimtwin-snipe-http"
  description = "HTTP traffic"
  vpc_id      = aws_vpc.bimtwin-snipe-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

resource "aws_security_group" "bimtwin-snipe-https" {
  name        = "bimtwin-snipe-https"
  description = "HTTPS traffic"
  vpc_id      = aws_vpc.bimtwin-snipe-vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

resource "aws_security_group" "bimtwin-snipe-ssh" {
  name        = "bimtwin-snipe-ssh"
  description = "SSH traffic"
  vpc_id      = aws_vpc.bimtwin-snipe-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

resource "aws_security_group" "bimtwin-snipe-api-ingress" {
  name        = "bimtwin-snipe-api-ingress"
  description = "Allow ingress to API"
  vpc_id      = aws_vpc.bimtwin-snipe-vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

resource "aws_security_group" "bimtwin-snipe-mysql-ingress" {
  name        = "bimtwin-snipe-mysql-ingress"
  description = "Allow ingress to MySQL"
  vpc_id      = aws_vpc.bimtwin-snipe-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

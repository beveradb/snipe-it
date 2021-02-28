data "aws_ami" "bimtwin-snipe-bastion-ami" {
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

resource "aws_security_group" "bimtwin-snipe-bastion-ingress" {
  name        = "bimtwin-snipe-bastion-security-group"
  description = "Allow HTTP, HTTPS and SSH traffic from anywhere"

  vpc_id = aws_vpc.bimtwin-snipe-vpc.id

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

  ingress {
    description = "HTTPTHREE"
    from_port   = 3000
    to_port     = 3000
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

resource "aws_instance" "bimtwin-snipe-bastion-instance" {
  key_name      = aws_key_pair.AndrewCurveMacBook2020RSA.key_name
  ami           = data.aws_ami.bimtwin-snipe-bastion-ami.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.bimtwin-snipe-bastion-subnet-one.id

  vpc_security_group_ids = [
    aws_security_group.bimtwin-snipe-egress-all.id,
    aws_security_group.bimtwin-snipe-ssh.id,
    aws_security_group.bimtwin-snipe-http.id,
    aws_security_group.bimtwin-snipe-https.id,
    aws_security_group.bimtwin-snipe-api-ingress.id,
    aws_security_group.bimtwin-snipe-mysql-ingress.id,
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("key")
    host        = self.public_ip
  }

  tags = local.tags
}

resource "aws_eip" "bimtwin-snipe-bastion-eip" {
  vpc      = true
  instance = aws_instance.bimtwin-snipe-bastion-instance.id

  tags = local.tags
}

output "instance_eip_dns_addr" {
  value = aws_eip.bimtwin-snipe-bastion-eip.public_dns
}

resource "aws_route53_record" "bimtwin-snipe-bastion-dns" {
  zone_id = data.aws_route53_zone.bimtwin-route53-zone.id
  name    = "bastion.bimtwin.ml"
  type    = "CNAME"
  ttl     = "5"
  records = [aws_eip.bimtwin-snipe-bastion-eip.public_dns]
}

output "bimtwin-snipe-bastion-dns-url" {
  value = "http://bastion.bimtwin.ml"
}

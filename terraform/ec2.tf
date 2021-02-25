resource "aws_subnet" "ubuntu-subnet" {
  cidr_block        = cidrsubnet(aws_vpc.ubuntu-vpc.cidr_block, 3, 1)
  vpc_id            = aws_vpc.ubuntu-vpc.id
  availability_zone = "${local.region}a"
  tags              = local.tags
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

output "instance_eip_dns_addr" {
  value = aws_eip.ubuntu-eip.public_dns
}

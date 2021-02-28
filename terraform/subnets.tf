resource "aws_subnet" "bimtwin-snipe-bastion-subnet-one" {
  cidr_block        = cidrsubnet(aws_vpc.bimtwin-snipe-vpc.cidr_block, 3, 1)
  vpc_id            = aws_vpc.bimtwin-snipe-vpc.id
  availability_zone = "${local.region}a"
  tags              = local.tags
}

resource "aws_subnet" "bimtwin-snipe-bastion-subnet-two" {
  cidr_block        = cidrsubnet(aws_vpc.bimtwin-snipe-vpc.cidr_block, 3, 4)
  vpc_id            = aws_vpc.bimtwin-snipe-vpc.id
  availability_zone = "${local.region}b"
  tags              = local.tags
}

resource "aws_route_table_association" "bimtwin-snipe-bastion-route-table-subnet-one-association" {
  subnet_id      = aws_subnet.bimtwin-snipe-bastion-subnet-one.id
  route_table_id = aws_route_table.bimtwin-snipe-route-table.id
}
resource "aws_route_table_association" "bimtwin-snipe-bastion-route-table-subnet-two-association" {
  subnet_id      = aws_subnet.bimtwin-snipe-bastion-subnet-two.id
  route_table_id = aws_route_table.bimtwin-snipe-route-table.id
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

resource "aws_subnet" "bimtwin-snipe-ecs-subnet-private" {
  cidr_block        = cidrsubnet(aws_vpc.bimtwin-snipe-vpc.cidr_block, 3, 5)
  vpc_id            = aws_vpc.bimtwin-snipe-vpc.id
  availability_zone = "${local.region}a"
  tags              = local.tags
}
resource "aws_subnet" "bimtwin-snipe-ecs-subnet-public" {
  cidr_block        = cidrsubnet(aws_vpc.bimtwin-snipe-vpc.cidr_block, 3, 6)
  vpc_id            = aws_vpc.bimtwin-snipe-vpc.id
  availability_zone = "${local.region}b"
  tags              = local.tags
}

resource "aws_route_table_association" "bimtwin-snipe-ecs-subnet-private-route-table-association" {
  subnet_id      = aws_subnet.bimtwin-snipe-ecs-subnet-private.id
  route_table_id = aws_route_table.bimtwin-snipe-route-table.id
}

resource "aws_route_table_association" "bimtwin-snipe-ecs-subnet-public-route-table-association" {
  subnet_id      = aws_subnet.bimtwin-snipe-ecs-subnet-public.id
  route_table_id = aws_route_table.bimtwin-snipe-route-table.id
}
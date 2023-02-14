resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block 

  tags = {
    Name = "test"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block_1 
  availability_zone = var.zone1               

  tags = {
    Name = "Public1-test"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block_2 
  availability_zone = var.zone2               

  tags = {
    Name = "Public2-test"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IGW-test"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route_table-test"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.example.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.example.id
}


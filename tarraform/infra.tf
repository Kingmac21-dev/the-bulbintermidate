resource "aws_vpc" "mac-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "mac-vpc"
  }
}
resource "aws_internet_gateway" "mac-igw" {
  vpc_id = aws_vpc.mac-vpc.id

  tags = {
    Name = "mac-igw"
  }
}
resource "aws_subnet" "mac-public-aws_subnet" {
  vpc_id     = aws_vpc.mac-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "mac-public-subnet"
  }
}
resource "aws_subnet" "mac-private-aws_subnet" {
  vpc_id     = aws_vpc.mac-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "mac-private-subnet"
  }
}
resource "aws_route_table" "mac-public-routetable" {
  vpc_id = aws_vpc.mac-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mac-igw.id
  }

  tags = {
    Name = "mac-public-routetable"
  }
}
resource "aws_route_table" "mac-private-routetable" {
  vpc_id = aws_vpc.mac-vpc.id

  tags = {
    Name = "mac-private-routetable"
  }
}
resource "aws_route_table_association" "macauley" {
  subnet_id      = aws_subnet.mac-public-aws_subnet.id
  route_table_id = aws_route_table.mac-public-routetable.id
}

provider "aws" { 
    access_key = ""
    secret_key = ""
    region = "us-east-1"
}

resource "aws_vpc" "mac-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "mac-igw" {
  vpc_id = aws_vpc.mac-vpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_subnet" "mac-public-subnet" {
  vpc_id     = aws_vpc.mac-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my-public-subnet"
  }
}

resource "aws_subnet" "mac-private-subnet" {
  vpc_id     = aws_vpc.mac-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "my-private-subnet"
  }
}

resource "aws_route_table" "mac-publicRT" {
  vpc_id = aws_vpc.mac-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mac-igw.id
  }

  tags = {
    Name = "my-publicRT"
  }
}

resource "aws_route_table" "mac-privateRT" {
  vpc_id = aws_vpc.mac-vpc.id

  tags = {
    Name = "my-privateRT"
  }
}

resource "aws_instance" "mac-public-instance" {
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.mac-public-subnet.id
  tags = {
    Name = "my-public-instance"
  }
}

resource "aws_instance" "mac-private-instance" {
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.mac-private-subnet.id
  tags = {
    Name = "my-private-instance"
  }
}
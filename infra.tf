

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
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true

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
  vpc_security_group_ids = [aws_security_group.mac-SG.id]
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

resource "aws_route_table_association" "mac-public-RTA" {
  subnet_id      = aws_subnet.mac-public-subnet.id
  route_table_id = aws_route_table.mac-publicRT.id
}

resource "aws_route_table_association" "mac-private-RTA" {
  subnet_id      = aws_subnet.mac-private-subnet.id
  route_table_id = aws_route_table.mac-privateRT.id
}

resource "aws_security_group" "mac-SG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.mac-vpc.id

  tags = {
    Name = "my-SG-IB"
  }
}

resource "aws_vpc_security_group_ingress_rule" "mac-SG-IB" {
  security_group_id = aws_security_group.mac-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "mac-SG-OB" {
  security_group_id = aws_security_group.mac-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

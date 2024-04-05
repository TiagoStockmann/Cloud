# VPC
resource "aws_vpc" "VPC-ANEIS" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "VPC-ANEIS"
  }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "IGW-ANEIS" {
  vpc_id = aws_vpc.VPC-ANEIS.id

  tags = {
    Name = "IGW-ANEIS"
  }
}

# SUBNET Subrede-Pub
resource "aws_subnet" "Subrede-Pub1" {
  vpc_id                  = aws_vpc.VPC-ANEIS.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Subrede-Pub1"
  }
}

# SUBNET Subrede-Pub
resource "aws_subnet" "Subrede-Pub2" {
  vpc_id                  = aws_vpc.VPC-ANEIS.id
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Subrede-Pub2"
  }
}

# SUBNET Subrede-Pri
resource "aws_subnet" "Subrede-Pri1" {
  vpc_id            = aws_vpc.VPC-ANEIS.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subrede-Pri1"
  }
}

# SUBNET Subrede-Pri
resource "aws_subnet" "Subrede-Pri2" {
  vpc_id            = aws_vpc.VPC-ANEIS.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Subrede-Pri2"
  }
}

# ROUTE TABLE Publica
resource "aws_route_table" "Rotas-ANEIS-Pub" {
  vpc_id = aws_vpc.VPC-ANEIS.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW-ANEIS.id
  }

  tags = {
    Name = "Rotas-ANEIS-Pub"
  }
}

# ROUTE TABLE Privada
resource "aws_route_table" "Rotas-ANEIS-Pri" {
  vpc_id = aws_vpc.VPC-ANEIS.id

  tags = {
    Name = "Rotas-ANEIS-Pri"
  }
}

# SUBNET ASSOCIATION Pub
resource "aws_route_table_association" "Subrede-Pub" {
  subnet_id      = aws_subnet.Subrede-Pub.id
  route_table_id = aws_route_table.Rotas-ANEIS-Pub.id
}

resource "aws_route" "Route-NAT-Gateway" {
  route_table_id            = aws_route_table.Rotas-ANEIS-Pri.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.NAT-Gateway.id
}

# SUBNET ASSOCIATION Pri (Associating private subnets with the updated route table)
resource "aws_route_table_association" "Subrede-Pri1" {
  subnet_id      = aws_subnet.Subrede-Pri1.id
  route_table_id = aws_route_table.Rotas-ANEIS-Pri.id
}

resource "aws_route_table_association" "Subrede-Pri2" {
  subnet_id      = aws_subnet.Subrede-Pri2.id
  route_table_id = aws_route_table.Rotas-ANEIS-Pri.id
}


#SUBNET ASSOCIATION Pri (Desafio NAT Gateway)
#resource "aws_route_table_association" "Subrede-Pri" {
#}

# NAT GATEWAY

# SECURITY GROUP
resource "aws_security_group" "Grupo-Sec-Linux" {
  name        = "Grupo-Sec-Linux"
  description = "Libera HTTP, SSH e ICMP"
  vpc_id      = aws_vpc.VPC-ANEIS.id


  ingress {
    description = "TCP/22 from All"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from All"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP/80 from All"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All to All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Grupo-Sec-Linux"
  }
}
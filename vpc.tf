#vpc 
resource "aws_vpc" "crm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "crm-vpc"
  }
}
#subnet
resource "aws_subnet" "crm-web-sn" {
  vpc_id     = aws_vpc.crm-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "crm-web-sn"
  }
}
resource "aws_subnet" "crm-api-sn" {
  vpc_id     = aws_vpc.crm-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "crm-api-sn"
  }
}
resource "aws_subnet" "crm-db-sn" {
  vpc_id     = aws_vpc.crm-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "crm-db-sn"
  }
}
#internet gateway
resource "aws_internet_gateway" "crm-igw" {
  vpc_id = aws_vpc.crm-vpc.id

  tags = {
    Name = "crm-igw"
  }
}
# crm public route table
resource "aws_route_table" "crm-public-rt" {
  vpc_id = aws_vpc.crm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.crm-igw.id
  }
  tags = {
    Name = "crm-public-rt"
  }
}
# crm pvt route table
resource "aws_route_table" "crm-pvt-rt" {
  vpc_id = aws_vpc.crm-vpc.id
  tags = {
    Name = "crm-pvt-rt"
  }
}
#crm-pub-asso
resource "aws_route_table_association" "crm-pub-ass" {
  subnet_id      = aws_subnet.crm-web-sn.id
  route_table_id = aws_route_table.crm-public-rt.id
}

resource "aws_route_table_association" "crm-api-pub-ass" {
  subnet_id      = aws_subnet.crm-api-sn.id
  route_table_id = aws_route_table.crm-public-rt.id
}
resource "aws_route_table_association" "crm-pvt-ass" {
  subnet_id      = aws_subnet.crm-db-sn.id
  route_table_id = aws_route_table.crm-pvt-rt.id
}

# nacls
resource "aws_network_acl" "crm-web-nacl" {
  vpc_id = aws_vpc.crm-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "crm-web-nacl"
  }
}
resource "aws_network_acl" "crm-api-nacl" {
  vpc_id = aws_vpc.crm-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "crm-api-nacl"
  }
}
resource "aws_network_acl" "crm-db-nacl" {
  vpc_id = aws_vpc.crm-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "crm-db-nacl"
  }
}
#crm web nacl
resource "aws_network_acl_association" "crm-web-nacl-asso" {
  network_acl_id = aws_network_acl.crm-web-nacl.id
  subnet_id      = aws_subnet.crm-web-sn.id
}
resource "aws_network_acl_association" "crm-api-nacl-asso" {
  network_acl_id = aws_network_acl.crm-api-nacl.id
  subnet_id      = aws_subnet.crm-api-sn.id
}
resource "aws_network_acl_association" "crm-web-db-asso" {
  network_acl_id = aws_network_acl.crm-db-nacl.id
  subnet_id      = aws_subnet.crm-db-sn.id
}
# security group
resource "aws_security_group" "crm-web-security" {
  name        = "crm-web-sg"
  description = "Allow ssh & http"
  vpc_id      = aws_vpc.crm-vpc.id

  tags = {
    Name = "crm-web-sg"
  }
}
# crm-web-security-group-ingress
resource "aws_vpc_security_group_ingress_rule" "crm-web-sg-ingress-ssh" {
  security_group_id = aws_security_group.crm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "crm-web-sg-ingress-http" {
  security_group_id = aws_security_group.crm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "crm-web-sg-engress" {
  security_group_id = aws_security_group.crm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
# security group
resource "aws_security_group" "crm-api-security" {
  name        = "crm-api-sg"
  description = "Allow ssh & nodejs"
  vpc_id      = aws_vpc.crm-vpc.id

  tags = {
    Name = "crm-api-sg"
  }
}
# crm-web-security-group-ingress
resource "aws_vpc_security_group_ingress_rule" "crm-api-sg-ingress-ssh" {
  security_group_id = aws_security_group.crm-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "crm-web-sg-ingress-nodejs" {
  security_group_id = aws_security_group.crm-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}
resource "aws_vpc_security_group_egress_rule" "crm-api-sg-engress" {
  security_group_id = aws_security_group.crm-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
# security group
resource "aws_security_group" "crm-db-security" {
  name        = "crm-db-sg"
  description = "Allow ssh & postgres"
  vpc_id      = aws_vpc.crm-vpc.id

  tags = {
    Name = "crm-db-sg"
  }
}
# crm-web-security-group-ingress
resource "aws_vpc_security_group_ingress_rule" "crm-db-sg-ingress-ssh" {
  security_group_id = aws_security_group.crm-db-sg.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "crm-db-sg-ingress-postgres" {
  security_group_id = aws_security_group.crm-web-sg.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}
resource "aws_vpc_security_group_egress_rule" "crm-db-sg-engress" {
  security_group_id = aws_security_group.crm-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
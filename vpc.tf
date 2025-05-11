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
  vpc_id = aws_vpc.vpc-crm.id

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
  vpc_id = aws_vpc.vpc-crm.id
  tags = {
    Name = "crm-pvt-rt"
  }
}

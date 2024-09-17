#state provider
provider "aws" {
  region = "us-east-1"
}

#create vpc
resource "aws_vpc" "cloudforce_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "cloudforce_vpc"
  }
}

#creating public subnet A
resource "aws_subnet" "cloudforce_publicA" {
  vpc_id            = aws_vpc.cloudforce_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "cloudforce_publicA"
  }
}

#creating private subnet A
resource "aws_subnet" "cloudforce_privateA" {
  vpc_id            = aws_vpc.cloudforce_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "cloudforce_privateA"
  }
}

#creating public subnet B
resource "aws_subnet" "cloudforce_publicB" {
  vpc_id            = aws_vpc.cloudforce_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "cloudforce_publicB"
  }
}


#creating private subnet B
resource "aws_subnet" "cloudforce_privateB" {
  vpc_id            = aws_vpc.cloudforce_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "cloudforce_privateB"
  }
}

#creating private subnet C
resource "aws_subnet" "cloudforce_privateC" {
  vpc_id            = aws_vpc.cloudforce_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "cloudforce_privateC"
  }
}
#creating private subnet D
resource "aws_subnet" "cloudforce_privateD" {
  vpc_id            = aws_vpc.cloudforce_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "cloudforce_privateD"
  }
}

#creating an internet gateway
resource "aws_internet_gateway" "cloudforce_igw" {
  vpc_id = aws_vpc.cloudforce_vpc.id

  tags = {
    "Name" = "cloudforce_igw"
  }
}

#creating a route table
resource "aws_route_table" "cloudforce_rtb" {
  vpc_id = aws_vpc.cloudforce_vpc.id

  tags = {
    "Name" = "cloudforce_rtb"
  }
}

#creating a route
resource "aws_route" "cloudforce_rt" {
  route_table_id         = aws_route_table.cloudforce_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cloudforce_igw.id
}

#associate route table to public subnet A
resource "aws_route_table_association" "cloudforce_rtb_assoc1" {
  subnet_id      = aws_subnet.cloudforce_publicA.id
  route_table_id = aws_route_table.cloudforce_rtb.id
}

#associate route table to public subnet B
resource "aws_route_table_association" "cloudforce_rtb_assoc2" {
  subnet_id      = aws_subnet.cloudforce_publicB.id
  route_table_id = aws_route_table.cloudforce_rtb.id
}

#create an elastic IP
resource "aws_eip" "cloud_natgateway_eip" {
  vpc = true # Ensures the EIP is allocated in the VPC context
}

#create a NAT gateway in public subnet A
resource "aws_nat_gateway" "cloudNAT" {
  subnet_id = aws_subnet.cloudforce_publicA.id

  #ensures that the EIP is created first
  depends_on = [aws_eip.cloud_natgateway_eip]

  #allocate Elastic IP to the NAT Gateway
  allocation_id = aws_eip.cloud_natgateway_eip.id

  tags = {
    "Name" = "NAT gateway 1"
  }
}

#create a Route Table for the NAT Gateway
resource "aws_route_table" "NAT_Gateway_RT" {
  depends_on = [aws_nat_gateway.cloudNAT]

  vpc_id = aws_vpc.cloudforce_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cloudNAT.id
  }

  tags = {
    "Name" = "Route Table for NAT Gateway"
  }

}

#Associating route table for NAT gateway to private subnet A
resource "aws_route_table_association" "Nat_Gateway_RT_Association_A" {
  depends_on = [aws_route_table.NAT_Gateway_RT]

  subnet_id      = aws_subnet.cloudforce_privateA.id
  route_table_id = aws_route_table.NAT_Gateway_RT.id
}

#Associating route table for NAT gateway to private subnet B
resource "aws_route_table_association" "Nat_Gateway_RT_Association_B" {
  depends_on = [aws_route_table.NAT_Gateway_RT]

  subnet_id      = aws_subnet.cloudforce_privateB.id
  route_table_id = aws_route_table.NAT_Gateway_RT.id
}
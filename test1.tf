provider "aws" {
  region = "us-east-1"
}

# Fetch available Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create an Internet Gateway for public subnets
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Create public subnet in the first availability zone
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 1"
  }
}

# Create private subnet in the first availability zone
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "Private Subnet 1"
  }
}

# Create public subnet in the second availability zone
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 2"
  }
}

# Create private subnet in the second availability zone
resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "Private Subnet 2"
  }
}

# Create a route table for the public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}

# Create a route to the internet in the public route table
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

# Associate the public route table with public subnets
resource "aws_route_table_association" "public_route_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Launch EC2 instance in public subnet 1
resource "aws_instance" "public_vm_1" {
  ami           = "ami-071226ecf16aa7d96"  # Update to a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "Public EC2 Instance 1"
  }
}

# Launch EC2 instance in public subnet 2
resource "aws_instance" "public_vm_2" {
  ami           = "ami-071226ecf16aa7d96"  # Update to a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_2.id
  tags = {
    Name = "Public EC2 Instance 2"
  }
}

# Optional: Launch EC2 instances in private subnets (you can adjust based on your needs)
# This example creates instances but they won’t be publicly accessible.

resource "aws_instance" "private_vm_1" {
  ami           = "ami-071226ecf16aa7d96"  # Update to a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1.id
  tags = {
    Name = "Private EC2 Instance 1"
  }
}

resource "aws_instance" "private_vm_2" {
  ami           = "ami-071226ecf16aa7d96"  # Update to a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_2.id
  tags = {
    Name = "Private EC2 Instance 2"
  }
}

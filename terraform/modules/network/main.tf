# main.tf for network module

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" # Placeholder CIDR block

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24" # Placeholder CIDR block
  availability_zone = "us-east-1a"  # Placeholder AZ

  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24" # Placeholder CIDR block
  availability_zone = "us-east-1b"  # Placeholder AZ

  tags = {
    Name = "private-subnet-b"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.101.0/24" # Placeholder CIDR block
  availability_zone       = "us-east-1a"    # Placeholder AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.102.0/24" # Placeholder CIDR block
  availability_zone       = "us-east-1b"    # Placeholder AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_security_group" "general" {
  name        = "general-sg"
  description = "General use security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all inbound traffic (adjust as needed)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "general-sg"
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.us-east-1.dynamodb" # Adjust region as needed
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "dynamodb-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.us-east-1.s3" # Adjust region as needed
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "s3-vpc-endpoint"
  }
}

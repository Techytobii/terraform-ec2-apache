resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

module "security_group" {
  source = "C:/Users/Oluwatobi/Desktop/terraform-apache-projects/terraform-ec2-apache/terraform-ec2-apache/modules/security_group"
  vpc_id = aws_vpc.main.id
}

module "ec2" {
  source            = "C:/Users/Oluwatobi/Desktop/terraform-apache-projects/terraform-ec2-apache/terraform-ec2-apache/modules/ec2"
  security_group_id = module.security_group.security_group_id
  subnet_id         = aws_subnet.public.id
  user_data         = file("${path.module}/apache_userdata.sh")
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform-needs-891377184590"
}

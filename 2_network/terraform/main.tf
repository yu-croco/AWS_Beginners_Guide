provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 3.0"
}
terraform {
  required_version = "= 0.12.29"
}

resource "aws_vpc" "infra-study-vpc" {
  cidr_block                     = "10.0.0.0/16"
  enable_classiclink             = false
  enable_classiclink_dns_support = false
  enable_dns_hostnames           = true
  instance_tenancy               = "default"
  enable_dns_support             = "true"
  tags = {
    Name = "infra-study-vpc"
  }
}

resource "aws_internet_gateway" "infra-study-igw" {
  vpc_id = aws_vpc.infra-study-vpc.id
  tags = {
    Name = "infra-study-igw"
  }
}

resource "aws_route_table" "infra-study-public-rtb" {
  vpc_id = aws_vpc.infra-study-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infra-study-igw.id
  }
  tags = {
    Name = "infra-study-public-rtb"
  }
}

resource "aws_subnet" "infra-study-public-subnet" {
  vpc_id            = aws_vpc.infra-study-vpc.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "infra-study-public-subnet"
  }
}

resource "aws_route_table_association" "infra-study-rtb-to-public-subnet" {
  subnet_id      = aws_subnet.infra-study-public-subnet.id
  route_table_id = aws_route_table.infra-study-public-rtb.id
}

# Security Group is devided by VPC
# anti-pattern to use default Security Group...!
resource "aws_security_group" "infra-study-sg" {
  name        = "infra-study-sg"
  description = "for infra study"
  vpc_id      = aws_vpc.infra-study-vpc.id
  tags = {
    Name = "infra-study-sg"
  }
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }
  ingress {
    // set your IP
    cidr_blocks      = [""]
    description      = "your IP address"
    from_port        = 22
    to_port          = 80
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
  }
}

resource "aws_iam_role" "infra-study" {
  name                  = "infra-study"
  assume_role_policy    = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Principal":{
        "Service":"ec2.amazonaws.com"
      },
      "Action":"sts:AssumeRole"
    }
  ]
}
EOF
  description           = "infra-study role"
  force_detach_policies = false
  tags = {
    Name = "infra-study"
  }
}

resource "aws_iam_instance_profile" "infra-study" {
  name = "infra-study"
  role = aws_iam_role.infra-study.name
}

resource "aws_iam_role_policy" "infra-study" {
  name   = "infra-study"
  role   = aws_iam_role.infra-study.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_instance" "infra-study" {
  ami           = "ami-0cc75a8978fbbc969"
  instance_type = "t2.micro"
  # create secret key and set the key name on 'key_name' below
  # see: https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-key-pairs.html
  key_name                    = ""
  subnet_id                   = aws_subnet.infra-study-public-subnet.id
  vpc_security_group_ids      = [aws_security_group.infra-study-sg.id]
  iam_instance_profile        = "infra-study"
  count                       = 1
  associate_public_ip_address = true
  user_data                   = file("../src/bin/user_data.sh")
  tags = {
    Name = "infra-study"
  }
}

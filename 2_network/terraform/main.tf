provider "aws" {
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      Env                = "dev"
      IsTerraformManaged = "true"
      System             = "infra-study"
    }
  }
}

terraform {
  required_version = "= 1.0.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.60"
    }
  }
}

resource "aws_vpc" "infra_study_vpc" {
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

resource "aws_internet_gateway" "infra_study_igw" {
  vpc_id = aws_vpc.infra_study_vpc.id
  tags = {
    Name = "infra-study-igw"
  }
}

resource "aws_route_table" "infra_study_public_rtb" {
  vpc_id = aws_vpc.infra_study_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infra_study_igw.id
  }
  tags = {
    Name = "infra-study-public-rtb"
  }
}

resource "aws_subnet" "infra_study_public_subnet" {
  vpc_id            = aws_vpc.infra_study_vpc.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "infra-study-public-subnet"
  }
}

resource "aws_route_table_association" "infra_study_rtb_to_public_subnet" {
  subnet_id      = aws_subnet.infra_study_public_subnet.id
  route_table_id = aws_route_table.infra_study_public_rtb.id
}

# Security Group is devided by VPC
# anti-pattern to use default Security Group...!
resource "aws_security_group" "infra_study_sg" {
  name        = "infra-study-sg"
  description = "for infra study"
  vpc_id      = aws_vpc.infra_study_vpc.id
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

resource "aws_iam_role" "infra_study" {
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

resource "aws_iam_instance_profile" "infra_study" {
  name = "infra-study"
  role = aws_iam_role.infra_study.name
}

resource "aws_iam_role_policy" "infra_study" {
  name   = "infra-study"
  role   = aws_iam_role.infra_study.id
  # see: https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:RunInstances",
        "ec2:AssociateIamInstanceProfile",
        "ec2:ReplaceIamInstanceProfileAssociation"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_instance" "infra_study" {
  ami           = "ami-0cc75a8978fbbc969"
  instance_type = "t2.micro"
  # create secret key and set the key name on 'key_name' below
  # see: https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-key-pairs.html
  key_name                    = ""
  subnet_id                   = aws_subnet.infra_study_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.infra_study_sg.id]
  iam_instance_profile        = "infra-study"
  count                       = 1
  associate_public_ip_address = true
  user_data                   = file("../src/bin/user_data.sh")
  tags = {
    Name = "infra-study"
  }
}

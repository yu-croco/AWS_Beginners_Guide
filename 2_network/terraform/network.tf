
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

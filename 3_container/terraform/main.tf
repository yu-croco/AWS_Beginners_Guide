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

resource "aws_iam_role" "infra-study" {
  name                  = "infra-study"
  assume_role_policy    = file("./config/iam/infra-study.json")
  description           = "infra-study"
  force_detach_policies = false
  tags                  = {
    Name = "infra-study"
  }
}

resource "aws_alb" "infra-study" {
  name                       = "infra-study"
  load_balancer_type         = "application"
  ip_address_type            = "ipv4"
  internal                   = false
  security_groups            = [aws_security_group.infra-study.id]
  subnets                    = [aws_subnet.infra-study.id]
  enable_deletion_protection = false
  access_logs {
    bucket  = ""
    prefix  = ""
    enabled = false
  }
  tags                  = {
    Name = "infra-study"
  }
}

resource "aws_alb_target_group" "infra-study" {
  name        = "infra-study"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.infra-study.id
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 150
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 120
    unhealthy_threshold = 5
  }
  tags                  = {
    Name = "infra-study"
  }
}

resource "aws_alb_listener" "infra-study" {
  load_balancer_arn = aws_alb.infra-study.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.infra-study.arn
    type             = "forward"
  }
  tags                  = {
    Name = "infra-study"
  }
}

resource "aws_cloudwatch_log_group" "infra-study" {
  name = "/ecs/infra-study"
  tags = {
    Name = "infra-study"
  }
}

resource "aws_ecr_repository" "infra-study" {
  name                 = "infra-study"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "infra-study"
  }
}

resource "aws_ecs_cluster" "infra-study" {
  name = "infra-study"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
  tags                  = {
    Name = "infra-study"
  }
}

resource "aws_ecs_task_definition" "infra-study" {
  family                   = "infra-study"
  container_definitions    = file("./config/ecs/infra-study.json")
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.infra-study.arn
  execution_role_arn       = aws_iam_role.infra-study.arn
  tags                  = {
    Name = "infra-study"
  }
}

resource "aws_ecs_service" "infra-study" {
  name                              = "infra-study"
  cluster                           = aws_ecs_cluster.infra-study.id
  task_definition                   = aws_ecs_task_definition.infra-study.arn
  desired_count                     = 1
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 120
  launch_type                       = "EC2"
  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.infra-study.id]
    subnets          = [aws_subnet.infra-study.id]
  }
  load_balancer {
    container_name   = "infra-study"
    container_port   = 80
    target_group_arn = aws_alb_target_group.infra-study.arn
  }
  deployment_controller {
    type = "ECS"
  }
  tags = {
    Name = "infra-study"
  }
}

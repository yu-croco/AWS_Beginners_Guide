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

resource "aws_route_table" "infra_study_public_rtb_2" {
  vpc_id = aws_vpc.infra_study_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infra_study_igw.id
  }
  tags = {
    Name = "infra-study-public-rtb-2"
  }
}

resource "aws_subnet" "infra_study_public_subnet_2" {
  vpc_id            = aws_vpc.infra_study_vpc.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.5.0/24"
  tags = {
    Name = "infra-study-public-subnet-2"
  }
}

resource "aws_route_table_association" "infra_study_rtb_to_public_subnet_2" {
  subnet_id      = aws_subnet.infra_study_public_subnet_2.id
  route_table_id = aws_route_table.infra_study_public_rtb_2.id
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
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 80
    to_port          = 80
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description      = ""
    from_port        = 443
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 443
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description      = ""
    from_port        = 8080
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 8080
  }
}

resource "aws_iam_role" "infra_study" {
  name                  = "infra-study"
  assume_role_policy    = file("./config/iam/infra-study.json")
  description           = "infra-study"
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
  // see: https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_execution_IAM_role.html
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeTags",
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:UpdateContainerInstancesState",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Action": [
        "ecs:DescribeServices",
        "ecs:CreateTaskSet",
        "ecs:UpdateServicePrimaryTaskSet",
        "ecs:DeleteTaskSet",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:ModifyRule",
        "lambda:InvokeFunction",
        "cloudwatch:DescribeAlarms",
        "sns:Publish",
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "iam:PassedToService": [
            "ecs-tasks.amazonaws.com"
          ]
        }
      }
    }
  ]
}
EOF
}

resource "aws_alb" "infra_study" {
  name                       = "infra-study"
  load_balancer_type         = "application"
  ip_address_type            = "ipv4"
  internal                   = false
  security_groups            = [aws_security_group.infra_study_sg.id]
  subnets                    = [aws_subnet.infra_study_public_subnet.id, aws_subnet.infra_study_public_subnet_2.id]
  enable_deletion_protection = false
  access_logs {
    bucket  = ""
    prefix  = ""
    enabled = false
  }
  tags = {
    Name = "infra-study"
  }
}

resource "aws_alb_target_group" "infra_study" {
  name        = "infra-study-tg"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.infra_study_vpc.id
  port        = 80
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = "infra-study"
  }
}

resource "aws_alb_listener" "infra_study" {
  load_balancer_arn = aws_alb.infra_study.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.infra_study.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "infra_study_2" {
  name        = "infra-study-tg-2"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.infra_study_vpc.id
  port        = 8080
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = "infra-study"
  }
}

resource "aws_alb_listener" "infra_study_2" {
  load_balancer_arn = aws_alb.infra_study.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.infra_study_2.arn
    type             = "forward"
  }
}

# for node.js application
resource "aws_cloudwatch_log_group" "infra_study" {
  name = "/ecs/infra-study"
  tags = {
    Name = "infra-study"
  }
}

resource "aws_cloudwatch_log_group" "infra_study_2" {
  name = "/ecs/infra-study-2"
  tags = {
    Name = "infra-study"
  }
}

resource "aws_ecr_repository" "infra_study" {
  name                 = "infra-study"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "infra-study"
  }
}

resource "aws_ecr_repository" "infra_study_2" {
  name                 = "infra-study-2"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "infra-study"
  }
}

resource "aws_ecs_cluster" "infra_study" {
  name = "infra-study-cluster"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
  tags = {
    Name = "infra-study"
  }
}

resource "aws_ecs_task_definition" "infra_study" {
  family                   = "infra-study"
  container_definitions    = file("./config/ecs/infra-study.json")
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.infra_study.arn
  execution_role_arn       = aws_iam_role.infra_study.arn
  tags = {
    Name = "infra-study"
  }
}

resource "aws_ecs_service" "infra_study" {
  name                              = "infra-study"
  cluster                           = aws_ecs_cluster.infra_study.id
  task_definition                   = aws_ecs_task_definition.infra_study.arn
  desired_count                     = 1
  health_check_grace_period_seconds = 120
  platform_version                  = "1.4.0"
  launch_type                       = "FARGATE"
  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.infra_study_sg.id]
    subnets          = [aws_subnet.infra_study_public_subnet.id]
  }
  load_balancer {
    container_name   = "infra-study"
    container_port   = 80
    target_group_arn = aws_alb_target_group.infra_study.arn
  }
  deployment_controller {
    type = "ECS"
  }
}

resource "aws_ecs_task_definition" "infra_study_2" {
  family                   = "infra-study-2"
  container_definitions    = file("./config/ecs/infra-study-2.json")
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.infra_study.arn
  execution_role_arn       = aws_iam_role.infra_study.arn
  tags = {
    Name = "infra-study"
  }
}

resource "aws_ecs_service" "infra_study_2" {
  name                              = "infra-study-2"
  cluster                           = aws_ecs_cluster.infra_study.id
  task_definition                   = aws_ecs_task_definition.infra_study_2.arn
  desired_count                     = 1
  health_check_grace_period_seconds = 120
  platform_version                  = "1.4.0"
  launch_type                       = "FARGATE"
  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.infra_study_sg.id]
    subnets          = [aws_subnet.infra_study_public_subnet_2.id]
  }
  load_balancer {
    container_name   = "infra-study-2"
    container_port   = 8080
    target_group_arn = aws_alb_target_group.infra_study_2.arn
  }
  deployment_controller {
    type = "ECS"
  }
}

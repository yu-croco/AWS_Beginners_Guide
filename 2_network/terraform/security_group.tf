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
    to_port          = 0
  }
  ingress {
    cidr_blocks     = [local.your_home_cidr]
    description     = "your IP address"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = []
  }
}

# Security Group is devided by VPC
# anti-pattern to use default Security Group...!
resource "aws_security_group" "infra_study_sg" {
  name        = "infra-study-sg-${var.owner}"
  description = "for infra study"
  vpc_id      = aws_vpc.infra_study_vpc.id
  tags = {
    Name = "infra-study-sg-${var.owner}"
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
    description      = "your IP address"
    from_port        = 80
    to_port          = 80
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = true
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "your IP address"
    from_port        = 8080
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = true
    to_port          = 8080
  }
}

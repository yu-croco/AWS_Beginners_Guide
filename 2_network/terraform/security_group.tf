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
    // FIXME set your IP
    cidr_blocks      = []
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
  assume_role_policy    = data.aws_iam_policy_document.ecs_assume_role_policy_doc.json
  description           = "infra-study role"
  force_detach_policies = false
  tags = {
    Name = "infra-study"
  }
}

data "aws_iam_policy_document" "ecs_assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "infra_study" {
  name = "infra-study"
  role = aws_iam_role.infra_study.name
}

resource "aws_iam_role_policy" "infra_study" {
  name = "infra-study"
  role = aws_iam_role.infra_study.id
  # see: https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html
  policy = data.aws_iam_policy_document.ec2_additional_policy_doc.json
}

data "aws_iam_policy_document" "ec2_additional_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
      "ec2:AssociateIamInstanceProfile",
      "ec2:ReplaceIamInstanceProfileAssociation",
    ]
    resources = ["*"]
  }
}

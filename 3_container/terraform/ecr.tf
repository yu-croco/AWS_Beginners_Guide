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

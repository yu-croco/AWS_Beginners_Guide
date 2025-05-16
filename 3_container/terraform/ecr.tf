resource "aws_ecr_repository" "nodejs_app" {
  name                 = "nodejs-app-${var.owner}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags = {
    Name = "golang-app-${var.owner}"
  }
}

resource "aws_ecr_repository" "golang_app" {
  name                 = "golang-app-${var.owner}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags = {
    Name = "golang-app-${var.owner}"
  }
}

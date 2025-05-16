# for node.js application
resource "aws_cloudwatch_log_group" "nodejs_app" {
  name = "/ecs/nodejs-app-${var.owner}"
  tags = {
    Name = "nodejs-app-${var.owner}"
  }
}

# for golang application
resource "aws_cloudwatch_log_group" "golang_app" {
  name = "/ecs/golang-app-${var.owner}"
  tags = {
    Name = "golang-app-${var.owner}"
  }
}

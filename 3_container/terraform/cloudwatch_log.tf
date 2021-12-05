# for node.js application
resource "aws_cloudwatch_log_group" "infra_study" {
  name = "/ecs/infra-study"
  tags = {
    Name = "infra-study"
  }
}

# for golang application
resource "aws_cloudwatch_log_group" "infra_study_2" {
  name = "/ecs/infra-study-2"
  tags = {
    Name = "infra-study"
  }
}

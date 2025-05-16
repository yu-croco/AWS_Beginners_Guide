# ECS ServiceとTask Definitionはecspressoで管理しているため、ここではECS Clusterのみ作成
resource "aws_ecs_cluster" "infra_study" {
  name = "infra-study-cluster-${var.owner}"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
  tags = {
    Name = "infra-study-${var.owner}"
  }
}

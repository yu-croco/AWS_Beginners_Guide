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

# Service Connectの設定はecspresso側に定義している。
resource "aws_service_discovery_private_dns_namespace" "infra_study" {
  name        = "infra-study-${var.owner}"
  description = "namespace for ECS infra-study-cluster-${var.owner}"
  vpc         = aws_vpc.infra_study_vpc.id
}

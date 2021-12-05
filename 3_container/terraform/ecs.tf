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
  container_definitions    = jsonencode(local.infra_study_1_task_definition)
  cpu                      = 512
  memory                   = 1024
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
  desired_count                     = 0
  health_check_grace_period_seconds = 120
  platform_version                  = "1.4.0"
  launch_type                       = "FARGATE"
  network_configuration {
    assign_public_ip = false
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
  container_definitions    = jsonencode(local.infra_study_2_task_definition)
  cpu                      = 512
  memory                   = 1024
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
  desired_count                     = 0
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

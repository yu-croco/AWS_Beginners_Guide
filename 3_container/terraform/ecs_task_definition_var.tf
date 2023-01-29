locals {
  infra_study_2_task_definition = [
    {
      cpu         = 512
      environment = []
      essential   = true
      image       = "${aws_ecr_repository.infra_study.repository_url}:latest"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.infra_study_2.name
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      mountPoints = []
      name        = "infra-study-2",
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ],
      secrets     = []
      volumesFrom = []
    }
  ]

  infra_study_1_task_definition = [
    {
      cpu         = 512
      environment = []
      essential   = true
      image       = "${aws_ecr_repository.infra_study_2.repository_url}:latest"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.infra_study.name
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      mountPoints = []
      name        = "infra-study"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      secrets     = []
      volumesFrom = []
    }
  ]
}

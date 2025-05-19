resource "aws_alb" "infra_study" {
  name                       = "infra-study-${var.owner}"
  load_balancer_type         = "application"
  ip_address_type            = "ipv4"
  internal                   = false
  security_groups            = [aws_security_group.infra_study_sg.id]
  subnets                    = [aws_subnet.infra_study_public_subnet.id, aws_subnet.infra_study_public_subnet_2.id]
  enable_deletion_protection = false
  access_logs {
    bucket  = ""
    prefix  = ""
    enabled = false
  }
  tags = {
    Name = "infra-study-${var.owner}"
  }
}

resource "aws_alb_target_group" "nodejs_app" {
  name        = "nodejs-app-tg-${var.owner}"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.infra_study_vpc.id
  port        = 80
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = "nodejs-app-${var.owner}"
  }
}

resource "aws_alb_listener" "nodejs_app" {
  load_balancer_arn = aws_alb.infra_study.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.nodejs_app.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "golang_app" {
  name        = "golang-app-tg-${var.owner}"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.infra_study_vpc.id
  port        = 8080
  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 4
  }
  tags = {
    Name = "golang-app-${var.owner}"
  }
}

resource "aws_alb_listener" "golang_app" {
  load_balancer_arn = aws_alb.infra_study.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.golang_app.arn
    type             = "forward"
  }
}

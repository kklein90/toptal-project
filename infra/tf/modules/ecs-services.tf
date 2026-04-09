resource "aws_ecs_service" "web" {
  name            = "web"
  cluster         = aws_ecs_cluster.ecs_cluster_01.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 0
  enable_execute_command             = true

  network_configuration {
    subnets          = local.ecs_public_subnet_ids
    security_groups  = [aws_security_group.web_server_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "web"
    container_port   = 8081
  }

  service_registries {
    registry_arn = aws_service_discovery_service.web.arn
  }

  depends_on = [
    aws_lb_listener_rule.web_host_rule
  ]

  tags = {
    Name         = "${var.env}-ecs-service-web"
    "account"    = var.env
    "owner"      = "techops"
    "management" = "terraform"
    "service"    = "infra"
  }
}

resource "aws_ecs_service" "api" {
  name            = "api"
  cluster         = aws_ecs_cluster.ecs_cluster_01.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 0
  enable_execute_command             = true

  network_configuration {
    subnets          = local.ecs_public_subnet_ids
    security_groups  = [aws_security_group.api_server_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api"
    container_port   = 8082
  }

  service_registries {
    registry_arn = aws_service_discovery_service.api.arn
  }

  depends_on = [
    aws_lb_listener_rule.api_host_rule
  ]

  tags = {
    Name         = "${var.env}-ecs-service-api"
    "account"    = var.env
    "owner"      = "techops"
    "management" = "terraform"
    "service"    = "infra"
  }
}

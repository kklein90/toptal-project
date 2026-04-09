resource "aws_ecs_cluster" "ecs_cluster_01" {
  name = "${var.env}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name         = "${var.env}-ecs-cluster"
    "account"    = var.env
    "owner"      = "techops"
    "management" = "terraform"
    "service"    = "infra"
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_01" {
  cluster_name = aws_ecs_cluster.ecs_cluster_01.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = "FARGATE"
  }
}

# Reuse public subnets from subnets.tf for ECS services/tasks that run on Fargate.
locals {
  ecs_public_subnet_ids = aws_subnet.public_subs_01[*].id
}

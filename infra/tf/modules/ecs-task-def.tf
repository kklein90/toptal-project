resource "aws_ecs_task_definition" "web" {
  family                   = "web"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = "${var.dockerhub-username}/toptal-web:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8081
          hostPort      = 8081
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "PORT"
          value = "8081"
        },
        {
          name  = "API_HOST"
          value = "api.toptal.internal"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.region
          awslogs-group         = aws_cloudwatch_log_group.web_loggroup.name
          awslogs-stream-prefix = "web"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "api" {
  family                   = "api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "api"
      image     = "${var.dockerhub-username}/toptal-api:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8082
          hostPort      = 8082
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "PORT"
          value = "8082"
        },
        {
          name  = "DBPORT"
          value = "5432"
        }
      ]
      secrets = [
        {
          name      = "DB"
          valueFrom = "/app/api/db"
        },
        {
          name      = "DBUSER"
          valueFrom = "/app/api/dbuser"
        },
        {
          name      = "DBPASS"
          valueFrom = "/app/api/dbpass"
        },
        {
          name      = "DBHOST"
          valueFrom = "/app/api/dbhost"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.region
          awslogs-group         = aws_cloudwatch_log_group.api_loggroup.name
          awslogs-stream-prefix = "api"
        }
      }
    }
  ])
}

resource "aws_service_discovery_private_dns_namespace" "asterkey_local_ecs_namespace" {
  name        = "toptal.internal"
  description = "service discovery domain"
  vpc         = aws_vpc.vpc_01.id

  tags = {
    usage     = "servicediscovery"
    managment = "terraform"
    owner     = "techops"
  }
}

resource "aws_service_discovery_service" "web" {
  name = "web"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.asterkey_local_ecs_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}

resource "aws_service_discovery_service" "api" {
  name = "api"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.asterkey_local_ecs_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}

resource "aws_service_discovery_service" "db" {
  name = "db"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.asterkey_local_ecs_namespace.id

    dns_records {
      ttl  = 10
      type = "CNAME"
    }

    routing_policy = "WEIGHTED"
  }
}

resource "aws_service_discovery_instance" "db" {
  instance_id = "primary"
  service_id  = aws_service_discovery_service.db.id

  attributes = {
    AWS_INSTANCE_CNAME = aws_db_instance.rds[0].address
  }
}

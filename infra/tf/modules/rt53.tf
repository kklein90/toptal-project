resource "aws_route53_zone" "toptal_internal" {
  name = "toptal.internal"
  vpc {
    vpc_id = data.aws_vpc.local_vpc.id
  }

  tags = {
    Name       = "toptal.internal"
    management = "terraform"
    owner      = "techops"
  }
}

resource "aws_route53_record" "toptal_internal_api" {
  zone_id = aws_route53_zone.toptal_internal.zone_id
  name    = "api"
  type    = "A"
  ttl     = 300
  records = [aws_instance.api_server.private_ip]

  depends_on = [aws_instance.api_server]
}

resource "aws_route53_record" "toptal_internal_web" {
  zone_id = aws_route53_zone.toptal_internal.zone_id
  name    = "web"
  type    = "A"
  ttl     = 300
  records = [aws_instance.web_server.private_ip]

  depends_on = [aws_instance.web_server]
}

resource "aws_route53_record" "toptal_internal_db" {
  zone_id = aws_route53_zone.toptal_internal.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.rds.address]

  depends_on = [aws_db_instance.rds]
}

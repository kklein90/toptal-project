resource "aws_lb" "toptal_alb" {
  name               = "toptal-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.toptal_alb_sg.id]
  subnets            = aws_subnet.public_subs_01[*].id

  tags = {
    Name         = "toptal-alb"
    "account"    = var.env
    "owner"      = "techops"
    "management" = "terraform"
    "service"    = "infra"
  }
}

resource "aws_lb_target_group" "web" {
  name        = "web"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc_01.id

  health_check {
    enabled = true
  }
}

resource "aws_lb_target_group" "api" {
  name        = "api"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc_01.id

  health_check {
    enabled = true
  }
}

resource "aws_lb_listener" "toptal_alb_http_80" {
  load_balancer_arn = aws_lb.toptal_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "api_host_rule" {
  listener_arn = aws_lb_listener.toptal_alb_http_80.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }

  condition {
    host_header {
      values = ["api.*", "api.${var.public_domain}"]
    }
  }
}

resource "aws_lb_listener_rule" "web_host_rule" {
  listener_arn = aws_lb_listener.toptal_alb_http_80.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  condition {
    host_header {
      values = ["web.*", "web.${var.public_domain}"]
    }
  }
}

resource "aws_security_group" "rds_sec_group" {
  name        = "RDS-Postgresql-common-security-group"
  description = "Standard SecGroup for MH RDS instances"
  vpc_id      = aws_vpc.vpc_01.id

  ingress {
    description = "Postgresql access from App subnets"
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    description = "Outbound access for updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_server_sg" {
  name        = "Web Sec Group"
  description = "sg for web"
  vpc_id      = aws_vpc.vpc_01.id

  ingress {
    description = "self"
    self        = true
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    description = "internal subnet ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["47.194.69.245/32"]
  }

  ingress {
    description = "https"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "ALB to web container"
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.toptal_alb_sg.id]
  }

  egress {
    description = "outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "api_server_sg" {
  name        = "API Sec Group"
  description = "sg for api"
  vpc_id      = aws_vpc.vpc_01.id

  ingress {
    description = "self"
    self        = true
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    description = "internal subnet ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["47.194.69.245/32"]
  }

  ingress {
    description = "https"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "ALB to api container"
    from_port       = 8082
    to_port         = 8082
    protocol        = "tcp"
    security_groups = [aws_security_group.toptal_alb_sg.id]
  }

  ingress {
    description     = "Web to API over Cloud Map"
    from_port       = 8082
    to_port         = 8082
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server_sg.id]
  }

  egress {
    description = "outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "toptal_alb_sg" {
  name        = "toptal-alb-sg"
  description = "Security group for public ALB"
  vpc_id      = aws_vpc.vpc_01.id

  ingress {
    description = "Allow HTTP inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "debian_latest" {
  most_recent = true
  owners      = ["136693071363"]
  filter {
    name   = "name"
    values = ["debian-*-arm64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}


resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.debian_latest.id
  instance_type               = var.worker-instance-type
  availability_zone           = aws_subnet.public_subs_01[0].availability_zone
  key_name                    = var.key-pair
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  subnet_id                   = aws_subnet.public_subs_01[0].id
  user_data                   = data.template_file.web_user_data.rendered
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.server_inst_profile.name

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
  }

  tags = {
    Name       = "web-server"
    management = "terraform"
    service    = "infra"
    owner      = "techops"
  }
}

data "template_file" "web_user_data" {
  template = file("${path.module}/web-user-data.tpl")
  vars = {
    inst_name = "web-svr"
  }
}

resource "aws_instance" "api_server" {
  ami                         = data.aws_ami.debian_latest.id
  instance_type               = var.worker-instance-type
  availability_zone           = aws_subnet.public_subs_01[0].availability_zone
  key_name                    = var.key-pair
  vpc_security_group_ids      = [aws_security_group.api_server_sg.id]
  subnet_id                   = aws_subnet.public_subs_01[0].id
  user_data                   = data.template_file.api_user_data.rendered
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.server_inst_profile.name

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
  }

  tags = {
    Name       = "api-server"
    management = "terraform"
    service    = "infra"
    owner      = "techops"
  }
}

data "template_file" "api_user_data" {
  template = file("${path.module}/api-user-data.tpl")
  vars = {
    inst_name = "api-svr"
  }
}

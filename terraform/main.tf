provider "aws" {
  region = var.region
}

resource "aws_security_group" "task_sg" {
  name        = "task_sg"
  description = "Allow inbound traffic from runner address"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP traffic from runner address"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      "${local.ifconfig_co_json.ip}/32",
      data.aws_vpc.default.cidr_block
    ]
  }

  ingress {
    description = "SSH traffic from runner address"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "${local.ifconfig_co_json.ip}/32",
      data.aws_vpc.default.cidr_block
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${local.prefix}-security-group"
  }, local.common_tags)
}

resource "aws_launch_template" "helloWorld" {
  name = "${local.prefix}-helloworld-launch-tmpl"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
    }
  }

  image_id = data.aws_ami.ubuntu.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.task_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = merge({
      Name = "${local.prefix}-helloworld"
    }, local.common_tags)
  }

  user_data = base64encode(data.template_file.helloWorld.rendered)

  tags = merge({
    Name = "${local.prefix}-launch-tmpl"
  }, local.common_tags)
}

data "template_file" "helloWorld" {
  template = <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y nginx
sudo service nginx start

rm /var/www/html/index.nginx-debian.html
echo "Hello world" > /var/www/html/index.html
EOF
}

resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    aws_security_group.task_sg.id
  ]
  subnets = data.aws_subnet_ids.default.ids

  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }

  tags = merge({
    Name = "${local.prefix}-elb"
  }, local.common_tags)
}

resource "aws_autoscaling_group" "asg_helloWorld" {
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  desired_capacity   = var.instance_count
  max_size           = var.instance_count
  min_size           = var.instance_count

  launch_template {
    id      = aws_launch_template.helloWorld.id
    version = aws_launch_template.helloWorld.latest_version
  }

  load_balancers = [
    aws_elb.web_elb.id
  ]
}

locals {
  prefix = "dmytro-prokhorenkov-${var.app}"
  common_tags = {
    owner       = local.prefix
    application = "HelloWorld"
    environment = var.env
  }
  ifconfig_co_json = jsondecode(data.http.my_public_ip.body)
}

### Getting local IP address of executor
data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

variable "region" {
  description = "Region used to deploy application"
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "Sets instance type for application"
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Sets amount of desired instances in autoscaling group"
  default     = 1
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Getting latest AMI for Amazon Linux 2
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  name_regex  = "^amzn2-ami-hvm-2.0.\\d{8}.0-x86_64-gp2$"
  owners      = ["amazon"]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  name_regex  = "^ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-\\d{8}$"
  owners      = ["099720109477"]
}

variable "app" {
  description = "Contains application name"
  default     = "helloWorld"
}

variable "env" {
  description = "Contains environment label where app is deployed"
  default     = "dev"
}
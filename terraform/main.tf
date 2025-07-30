terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "ec2-security-group" {
  name        = var.security_group
  vpc_id      = var.vpc
  description = "allow all internal traffic, ssh, http, https from anywhere"
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = "true"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "windows_instance_1" {
  instance_type        = var.windows_instance_type
  ami                  = lookup(var.windows_amis, var.aws_region)
  get_password_data    = true
  key_name = var.key_name
  security_groups      = ["${aws_security_group.ec2-security-group.name}"]
  iam_instance_profile = var.iam_role
  associate_public_ip_address = true
}

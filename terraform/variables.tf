variable "aws_region" {
  description = "Default region"
}

variable "vpc" {
  description = "VPC to use"
}

variable "windows_instance_type" {
  description = "EC2 instance type to deploy"
}

variable "windows_amis" {
  description = "Windows AMI to use"
}

variable "key_name" {
  description = "SSH key name"
}

variable "iam_role" {
  description = "IAM role to assign EC2"
}

variable "security_group" {
  description = "Security group for EC2"
}

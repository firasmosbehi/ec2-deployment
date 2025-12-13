variable "aws_region" {}
variable "environment" {}
variable "ec2_key_name" {}
variable "instance_type" {}
variable "db_username" {}
variable "db_password" {}
variable "db_instance_class" {}
variable "vpc_cidr" {}
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "az_count" { type = number }

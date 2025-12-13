variable "aws_region" {
  type = string
}

variable "ec2_key_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "az_count" {
  type = number
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default = "../../../ressources/ssh-keys/my-key.pub"
}

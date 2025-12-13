provider "aws" {
  region = var.aws_region
}

module "infra" {
  source               = "../../modules/infrastructure"
  aws_region           = var.aws_region
  environment          = var.environment
  ec2_key_name         = var.ec2_key_name
  instance_type        = var.instance_type
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  az_count             = var.az_count
}

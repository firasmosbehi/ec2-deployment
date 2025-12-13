resource "aws_db_subnet_group" "rds" {
  name       = "${var.environment}-rds-subnets"
  subnet_ids = aws_subnet.private[*].id
  tags       = { Name = "${var.environment}-rds-subnets" }
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.environment}-postgres"
  engine                 = "postgres"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  db_name                = "${var.environment}_db"
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  publicly_accessible    = false
  multi_az               = var.az_count == 2 ? true : false
  skip_final_snapshot    = true
}

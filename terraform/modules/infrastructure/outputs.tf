output "vpc_id" { value = aws_vpc.main.id }
output "public_subnets" { value = aws_subnet.public[*].id }
output "private_subnets" { value = aws_subnet.private[*].id }
output "ec2_public_ip" { value = aws_instance.app.public_ip }
output "ec2_public_dns" {
  description = "Public  DNS of the EC2 instance"
  value = aws_instance.app.public_dns
}

# RDS endpoint (host)
output "rds_endpoint" {
  description = "The RDS instance endpoint (host)"
  value       = aws_db_instance.postgres.address
}

# RDS port
output "rds_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.postgres.port
}

# Database username
output "rds_username" {
  description = "The master username of the RDS instance"
  value       = aws_db_instance.postgres.username
}

# Database password (sensitive!)
output "rds_password" {
  description = "The master password of the RDS instance"
  value       = aws_db_instance.postgres.password
  sensitive = true
}

output "rds_db_name" {
  description = "The name of the RDS database"
  value       = aws_db_instance.postgres.db_name
}
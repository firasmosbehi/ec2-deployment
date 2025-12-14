output "vpc_id" { value = aws_vpc.main.id }
output "public_subnets" { value = aws_subnet.public[*].id }
output "private_subnets" { value = aws_subnet.private[*].id }
output "ec2_public_ip" { value = aws_instance.app.public_ip }
output "rds_endpoint" { value = aws_db_instance.postgres.address }
output "ec2_public_dns" {
  description = "Public  DNS of the EC2 instance"
  value = aws_instance.app.public_dns
}


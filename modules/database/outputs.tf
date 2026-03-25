output "db_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "db_instance_id" {
  description = "RDS database instance ID"
  value       = aws_db_instance.mysql.id
}

output "db_security_group_id" {
  description = "Security group ID for database"
  value       = aws_security_group.db_sg.id
}

output "db_port" {
  description = "Database port"
  value       = aws_db_instance.mysql.port
}

output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.app[*].id
}

output "instance_ips" {
  description = "List of EC2 instance private IPs"
  value       = aws_instance.app[*].private_ip
}

output "security_group_id" {
  description = "Security group ID for instances"
  value       = aws_security_group.instance_sg.id
}

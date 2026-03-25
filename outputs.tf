output "load_balancer_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.load_balancer.alb_dns
}

output "load_balancer_target_group" {
  description = "Target group ARN of the load balancer"
  value       = module.load_balancer.target_group_arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnets" {
  description = "IDs of public subnets"
  value       = module.networking.public_subnets
}

output "private_subnets" {
  description = "IDs of private subnets"
  value       = module.networking.private_subnets
}

output "ec2_instance_ids" {
  description = "IDs of EC2 instances"
  value       = module.compute.instance_ids
}

output "ec2_instance_ips" {
  description = "Private IPs of EC2 instances"
  value       = module.compute.instance_ips
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.db_endpoint
  sensitive   = true
}

output "database_instance_id" {
  description = "RDS database instance ID"
  value       = module.database.db_instance_id
}

output "database_port" {
  description = "Database port"
  value       = module.database.db_port
}


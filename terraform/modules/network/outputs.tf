# outputs.tf for network module

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets."
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets."
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "main_security_group_id" {
  description = "The ID of the main security group."
  value       = aws_security_group.general.id
}

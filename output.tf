output "instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = aws_instance.web[*].id
}

output "elastic_ips" {
  description = "The Elastic IPs"
  value       = aws_eip.lb[*].public_ip
}
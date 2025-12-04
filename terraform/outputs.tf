output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = try(aws_lb.main.dns_name, "ALB not created yet")
}

output "alb_url" {
  description = "URL of the ALB"
  value       = "http://${try(aws_lb.main.dns_name, "ALB-not-created")}"
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = try(aws_lb_target_group.app.arn, "")
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = try(aws_autoscaling_group.app.name, "")
}

output "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  value       = try(aws_security_group.ec2.id, "")
}

output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = try(aws_security_group.alb.id, "")
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = try(aws_subnet.private[*].id, [])
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = try(aws_subnet.public[*].id, [])
}

# Add instance IDs for testing
output "instance_ids" {
  description = "IDs of EC2 instances"
  value = try(
    aws_autoscaling_group.app.instances[*].id,
    []
  )
}

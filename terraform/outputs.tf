output "vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.main.id, "")
  sensitive   = false
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = try(aws_lb.main.dns_name, "")
  sensitive   = false
}

output "alb_url" {
  description = "URL of the ALB"
  value       = "http://${try(aws_lb.main.dns_name, "ALB-not-created-yet")}"
  sensitive   = false
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = try(aws_lb_target_group.app.arn, "")
  sensitive   = false
}

output "target_group_name" {
  description = "Name of the target group"
  value       = try(aws_lb_target_group.app.name, "")
  sensitive   = false
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = try(aws_autoscaling_group.app.name, "")
  sensitive   = false
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = try(aws_autoscaling_group.app.arn, "")
  sensitive   = false
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = try(aws_launch_template.app.id, "")
  sensitive   = false
}

output "launch_template_name" {
  description = "Name of the launch template"
  value       = try(aws_launch_template.app.name, "")
  sensitive   = false
}

output "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  value       = try(aws_security_group.ec2.id, "")
  sensitive   = false
}

output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = try(aws_security_group.alb.id, "")
  sensitive   = false
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = try(aws_subnet.private[*].id, [])
  sensitive   = false
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = try(aws_subnet.public[*].id, [])
  sensitive   = false
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = try(aws_nat_gateway.main.id, "")
  sensitive   = false
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = try(aws_internet_gateway.main.id, "")
  sensitive   = false
}

output "availability_zones" {
  description = "Availability zones used"
  value       = var.availability_zones
  sensitive   = false
}

# Optional: Output instance information using data source
output "instance_info" {
  description = "Information about EC2 instances"
  value = {
    instance_type = var.instance_type
    app_port      = var.app_port
    desired_count = var.desired_capacity
    health_check  = var.health_check_path
  }
  sensitive = false
}

# If you want to get actual instance IDs, you need to use a data source
# This requires instances to be already running
data "aws_instances" "asg_instances" {
  count = var.desired_capacity > 0 ? 1 : 0
  
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [try(aws_autoscaling_group.app.name, "")]
  }
  
  filter {
    name   = "instance-state-name"
    values = ["running", "pending"]
  }
  
  depends_on = [aws_autoscaling_group.app]
}

output "instance_ids" {
  description = "IDs of EC2 instances in the ASG"
  value       = try(data.aws_instances.asg_instances[0].ids, [])
  sensitive   = false
}

output "instance_count" {
  description = "Number of running instances"
  value       = try(length(data.aws_instances.asg_instances[0].ids), 0)
  sensitive   = false
}

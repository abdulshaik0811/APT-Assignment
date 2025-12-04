###############################
# LOAD BALANCER OUTPUT
###############################
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

###############################
# AUTOSCALING GROUP NAME
###############################
output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

###############################
# VPC ID
###############################
output "vpc_id" {
  value = aws_vpc.main.id
}

###############################
# PRIVATE SUBNET IDs
###############################
output "private_subnets" {
  value = [for s in aws_subnet.private : s.id]
}

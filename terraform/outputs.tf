output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  value = [for s in aws_subnet.private : s.id]
}

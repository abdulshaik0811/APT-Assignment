############################################
# OUTPUT: ALB DNS NAME
############################################
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

############################################
# OUTPUT: VPC ID
############################################
output "vpc_id" {
  value = aws_vpc.main.id
}

############################################
# OUTPUT: PRIVATE SUBNET IDS
############################################
output "private_subnets" {
  value = [for s in aws_subnet.private : s.id]
}

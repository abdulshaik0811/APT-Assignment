resource "aws_lb" "alb" {
  name = "oneclick-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [for s in aws_subnet.public : s.id]
  tags = { Name = "oneclick-alb" }
}

resource "aws_lb_target_group" "tg" {
  name = "oneclick-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id

  health_check {
    path = "/health"; matcher = "200"
    interval = 30; healthy_threshold = 2; unhealthy_threshold = 2; timeout = 5
  }
  tags = { Name = "oneclick-tg" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80; protocol = "HTTP"
  default_action { type = "forward"; target_group_arn = aws_lb_target_group.tg.arn }
}

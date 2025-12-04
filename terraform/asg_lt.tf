data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter { name = "name"; values = ["amzn2-ami-hvm-*-x86_64-gp2"] }
}

resource "aws_launch_template" "lt" {
  name_prefix = "oneclick-lt-"
  image_id = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  iam_instance_profile { name = aws_iam_instance_profile.ec2_profile.name }
  key_name = var.key_name != "" ? var.key_name : null

  network_interfaces {
    security_groups = [aws_security_group.app_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(<<-USERDATA
    #!/bin/bash
    set -e
    yum update -y

    # install minimal packages
    curl -sL https://rpm.nodesource.com/setup_18.x | bash -
    yum install -y nodejs git awslogs

    # configure awslogs with Terraform region
    sed -i "s/region = .*/region = ${var.aws_region}/" /etc/awslogs/awslogs.conf || true

    # cloudwatch config
    cat > /etc/awslogs/config/oneclick-app.conf <<'EOF'
    [/var/log/app.log]
    file = /var/log/app.log
    log_group_name = /oneclick/app
    log_stream_name = {instance_id}
    datetime_format = %Y-%m-%d %H:%M:%S
    EOF

    systemctl enable awslogsd || true
    systemctl start awslogsd || true

    # ensure app dir and ownership
    mkdir -p /home/ec2-user/${var.app_dir}
    chown -R ec2-user:ec2-user /home/ec2-user/${var.app_dir}

    # clone repo if provided (run as ec2-user)
    if [ -n "${var.app_repo}" ] && [ ! -f /home/ec2-user/${var.app_dir}/server.js ]; then
      cd /home/ec2-user || true
      if command -v git >/dev/null 2>&1; then
        sudo -u ec2-user git clone "${var.app_repo}" repo || true
        if [ -d "repo/${var.app_dir}" ]; then
          mv "repo/${var.app_dir}" "${var.app_dir}" || true
        elif [ -d "repo" ]; then
          mv repo "${var.app_dir}" || true
        fi
      fi
      chown -R ec2-user:ec2-user /home/ec2-user/${var.app_dir}
    fi

    # install deps & start app as ec2-user
    if [ -f /home/ec2-user/${var.app_dir}/package.json ]; then
      sudo -u ec2-user bash -lc "cd /home/ec2-user/${var.app_dir} && npm install --production || true"
      sudo -u ec2-user bash -lc "cd /home/ec2-user/${var.app_dir} && nohup node server.js > /var/log/app.log 2>&1 & echo \$! > /var/run/oneclick_app.pid"
    fi

    # enable ssm agent if present
    if systemctl list-unit-files | grep -q amazon-ssm-agent; then
      systemctl enable amazon-ssm-agent || true
      systemctl start amazon-ssm-agent || true
    fi
  USERDATA
  )
}

resource "aws_autoscaling_group" "asg" {
  name = "oneclick-asg"
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  vpc_zone_identifier = [for s in aws_subnet.private : s.id]

  launch_template { id = aws_launch_template.lt.id; version = "$Latest" }

  target_group_arns = [aws_lb_target_group.tg.arn]
  health_check_type = "ELB"
  health_check_grace_period = 120

  tag { key = "Name"; value = "oneclick-asg-instance"; propagate_at_launch = true }

  lifecycle { create_before_destroy = true }
}

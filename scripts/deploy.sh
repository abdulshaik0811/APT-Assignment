#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/../terraform"
terraform init -input=false
terraform apply -auto-approve
echo
echo "ALB DNS:"
terraform output -raw alb_dns_name || terraform output alb_dns_name

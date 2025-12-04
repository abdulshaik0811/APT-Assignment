#!/bin/bash
set -e

echo "Starting deployment..."

# Initialize Terraform
cd terraform
terraform init

# Apply Terraform
terraform apply -auto-approve

# Get ALB DNS
ALB_DNS=$(terraform output -raw alb_dns_name)
echo "ALB DNS Name: http://$ALB_DNS"
echo "Deployment complete!"

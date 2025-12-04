#!/bin/bash
set -e

echo "Testing deployment..."

# Get ALB DNS from Terraform output
ALB_DNS=$(cd terraform && terraform output -raw alb_dns_name)

# Test API endpoint
echo "Testing API endpoint..."
curl -f "http://$ALB_DNS/"

# Test health endpoint
echo -e "\nTesting health endpoint..."
curl -f "http://$ALB_DNS/health"

echo -e "\nAll tests passed!"

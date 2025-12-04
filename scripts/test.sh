#!/bin/bash
set -e

echo "Testing deployment..."

# Change to terraform directory
cd terraform

# Get ALB DNS from Terraform output
echo "Getting ALB DNS from Terraform..."
ALB_DNS=$(terraform output -raw alb_dns_name 2>/dev/null || echo "")

if [ -z "$ALB_DNS" ] || [ "$ALB_DNS" = "ALB not created yet" ]; then
    echo "ERROR: ALB DNS not found in Terraform outputs"
    echo "Running 'terraform output' to see available outputs:"
    terraform output
    echo ""
    echo "Possible solutions:"
    echo "1. Run 'terraform apply' first to create the infrastructure"
    echo "2. Check if outputs are defined in outputs.tf"
    exit 1
fi

echo "ALB DNS Name: $ALB_DNS"
echo ""

# Wait for ALB to be ready (optional)
echo "Waiting for ALB to be ready..."
sleep 30

# Test API endpoint
echo "Testing API endpoint..."
MAX_RETRIES=10
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    echo "Attempt $((RETRY_COUNT + 1)) of $MAX_RETRIES..."
    
    if curl -f -s -o /dev/null -w "HTTP Status: %{http_code}\n" "http://$ALB_DNS/"; then
        echo "✓ API endpoint is accessible"
        break
    else
        echo "✗ API endpoint not accessible, retrying in 10 seconds..."
        RETRY_COUNT=$((RETRY_COUNT + 1))
        sleep 10
    fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "ERROR: API endpoint not accessible after $MAX_RETRIES attempts"
    exit 1
fi

# Test health endpoint
echo ""
echo "Testing health endpoint..."
curl -f -s "http://$ALB_DNS/health" | jq . || curl -f -s "http://$ALB_DNS/health"

# Test info endpoint (if available)
echo ""
echo "Testing info endpoint..."
curl -s "http://$ALB_DNS/info" | jq . 2>/dev/null || curl -s "http://$ALB_DNS/info" || echo "Info endpoint not available"

echo ""
echo "All tests passed successfully!"

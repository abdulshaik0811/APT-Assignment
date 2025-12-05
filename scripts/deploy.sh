#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to check command execution
check_exit() {
    if [ $? -ne 0 ]; then
        print_error "$1"
        exit 1
    fi
}

# Check if terraform directory exists
if [ ! -d "terraform" ]; then
    print_error "terraform directory not found!"
    exit 1
fi

# Check if terraform.tfvars exists
if [ ! -f "terraform/terraform.tfvars" ]; then
    print_warning "terraform.tfvars not found. Creating from example..."
    if [ -f "terraform/terraform.tfvars.example" ]; then
        cp terraform/terraform.tfvars.example terraform/terraform.tfvars
        print_warning "Please update terraform/terraform.tfvars with your values"
        exit 1
    else
        print_error "terraform.tfvars.example not found!"
        exit 1
    fi
fi

# Navigate to terraform directory
cd terraform

# Step 1: Initialize Terraform
print_status "Step 1: Initializing Terraform..."
terraform init
check_exit "Terraform initialization failed!"

# Step 2: Validate configuration
print_status "Step 2: Validating Terraform configuration..."
terraform validate
check_exit "Terraform validation failed!"

# Step 3: Format code
print_status "Step 3: Formatting Terraform code..."
terraform fmt -recursive

# Step 4: Create execution plan
print_status "Step 4: Creating Terraform execution plan..."
terraform plan -out=tfplan
check_exit "Terraform plan creation failed!"

# Step 5: Apply configuration
print_status "Step 5: Applying Terraform configuration..."
print_warning "This will create AWS resources. Press Ctrl+C to abort in 5 seconds..."
sleep 5

terraform apply tfplan
check_exit "Terraform apply failed!"

# Step 6: Get outputs
print_status "Step 6: Retrieving deployment outputs..."
ALB_DNS=$(terraform output -raw alb_dns_name)
APPLICATION_URL=$(terraform output -raw application_url)

# Step 7: Wait for instances to be healthy
print_status "Step 7: Waiting for instances to be healthy (this may take 2-3 minutes)..."
sleep 60

# Step 8: Test the application
print_status "Step 8: Testing application connectivity..."
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -s --connect-timeout 5 "http://$ALB_DNS/health" > /dev/null; then
        print_success "Application is responding!"
        break
    fi
    
    RETRY_COUNT=$((RETRY_COUNT + 1))
    print_status "Waiting for application to be ready... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 10
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    print_warning "Application is taking longer than expected to start"
    print_warning "You can manually check later with: curl http://$ALB_DNS"
fi

# Step 9: Display deployment summary
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}      DEPLOYMENT COMPLETED SUCCESSFULLY    ${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}📱 Application URL:${NC}"
echo -e "   ${BLUE}http://$ALB_DNS${NC}"
echo ""
echo -e "${YELLOW}🔗 Additional Endpoints:${NC}"
echo -e "  

#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Terraform deployment...${NC}"
echo ""

# Initialize Terraform
echo -e "${YELLOW}Step 1: Initializing Terraform...${NC}"
terraform init
if [ $? -ne 0 ]; then
    echo -e "${RED}Terraform init failed!${NC}"
    exit 1
fi

# Validate Terraform configuration
echo -e "${YELLOW}Step 2: Validating Terraform configuration...${NC}"
terraform validate
if [ $? -ne 0 ]; then
    echo -e "${RED}Terraform validation failed!${NC}"
    exit 1
fi

# Plan the deployment
echo -e "${YELLOW}Step 3: Planning Terraform deployment...${NC}"
terraform plan -out=tfplan
if [ $? -ne 0 ]; then
    echo -e "${RED}Terraform plan failed!${NC}"
    exit 1
fi

# Apply the plan
echo -e "${YELLOW}Step 4: Applying Terraform configuration...${NC}"
terraform apply tfplan
if [ $? -ne 0 ]; then
    echo -e "${RED}Terraform apply failed!${NC}"
    exit 1
fi

# Get ALB DNS name
echo -e "${YELLOW}Step 5: Retrieving ALB DNS name...${NC}"
ALB_DNS=$(terraform output -raw alb_dns_name)
APPLICATION_URL=$(terraform output -raw application_url)

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}ALB DNS Name:${NC} ${ALB_DNS}"
echo -e "${YELLOW}Application URL:${NC} ${APPLICATION_URL}"
echo ""
echo -e "${GREEN}Access the application at: http://${ALB_DNS}${NC}"
echo ""
echo -e "${YELLOW}Note: It may take 2-3 minutes for the instances to register with the ALB.${NC}"
echo ""

# Save the DNS name to a file
echo "${ALB_DNS}" > alb_dns.txt
echo "Application URL: http://${ALB_DNS}" >> alb_dns.txt

echo -e "${GREEN}You can test the connection with:${NC}"
echo "curl http://${ALB_DNS}"
echo ""
echo -e "${GREEN}Or open the URL in your web browser.${NC}"

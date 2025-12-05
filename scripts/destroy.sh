#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Terraform destroy...${NC}"
echo ""

# Confirm destruction
read -p "Are you sure you want to destroy all infrastructure? (yes/no): " confirmation

if [ "$confirmation" != "yes" ]; then
    echo -e "${YELLOW}Destroy cancelled.${NC}"
    exit 0
fi

# Destroy infrastructure
echo -e "${YELLOW}Destroying Terraform infrastructure...${NC}"
terraform destroy -auto-approve

if [ $? -ne 0 ]; then
    echo -e "${RED}Terraform destroy failed!${NC}"
    exit 1
fi

# Clean up local files
echo -e "${YELLOW}Cleaning up local files...${NC}"
if [ -f "alb_dns.txt" ]; then
    rm -f alb_dns.txt
fi

if [ -f "tfplan" ]; then
    rm -f tfplan
fi

if [ -f "terraform.tfstate.backup" ]; then
    rm -f terraform.tfstate.backup
fi

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}All infrastructure has been destroyed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}Note: Some resources may take a few minutes to fully delete from AWS.${NC}"

#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Applying API Gateway Ingress with SSL/TLS Certificate ===${NC}"

# Check if we're in the right directory
if [ ! -d "./terraform" ] || [ ! -d "./manifests" ]; then
  echo -e "${RED}Error: Script must be run from project root directory${NC}"
  exit 1
fi

# Get certificate ARN from terraform outputs
cd terraform
echo -e "${YELLOW}Retrieving SSL certificate ARN from Terraform...${NC}"
CERTIFICATE_ARN=$(terraform output -raw certificate_arn 2>/dev/null)

if [ -z "$CERTIFICATE_ARN" ] || [ "$CERTIFICATE_ARN" == "" ]; then
  echo -e "${RED}Error: Could not retrieve certificate ARN from Terraform outputs.${NC}"
  echo -e "${YELLOW}Have you applied your Terraform configuration with the ACM module?${NC}"
  cd ..
  exit 1
fi

cd ..

# Create temporary ingress file with the actual ARN
INGRESS_FILE="./manifests/networking/api-gateway-ingress.yaml"
TEMP_INGRESS_FILE="./manifests/networking/api-gateway-ingress-temp.yaml"

echo -e "${YELLOW}Creating temporary ingress file with certificate ARN: $CERTIFICATE_ARN${NC}"

# Replace the placeholder with the actual ARN
sed "s|\${ACM_CERTIFICATE_ARN}|$CERTIFICATE_ARN|g" "$INGRESS_FILE" > "$TEMP_INGRESS_FILE"

# Apply the ingress
echo -e "${YELLOW}Applying ingress with kubectl...${NC}"
kubectl apply -f "$TEMP_INGRESS_FILE"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully applied API Gateway ingress with HTTPS enabled!${NC}"
else
  echo -e "${RED}Failed to apply API Gateway ingress${NC}"
  exit 1
fi

# Clean up temporary file
rm "$TEMP_INGRESS_FILE"

echo -e "${BLUE}=== Completed ===${NC}"
echo -e "${YELLOW}Your API Gateway will be available at the ALB address with both HTTP and HTTPS.${NC}"
echo -e "${YELLOW}Note: You may need to wait a few minutes for the ALB to provision and the certificate to be associated.${NC}"
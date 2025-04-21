#!/bin/bash

# Cleanup script to remove application resources before running terraform destroy
# This script ensures a clean state before destroying infrastructure

set -e  # Exit on any error

LIGHTBLUE='\033[1;36m'
LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${LIGHTBLUE}=========================================================${NC}"
echo -e "${LIGHTBLUE}    Cleaning up Kubernetes resources before terraform destroy${NC}"
echo -e "${LIGHTBLUE}=========================================================${NC}"

# Check kubectl connection
echo -e "${LIGHTBLUE}Checking kubectl connection to cluster...${NC}"
if ! kubectl get nodes &>/dev/null; then
  echo -e "${LIGHTRED}ERROR: Cannot connect to Kubernetes cluster${NC}"
  echo "Make sure your kubeconfig is properly configured"
  exit 1
fi

echo -e "${LIGHTBLUE}Connected to cluster. Starting cleanup...${NC}"

# Function to delete resources with a timeout
delete_with_timeout() {
  local resource_type=$1
  local selector=$2
  local namespace=$3
  local timeout=$4
  local message=$5

  echo -e "${LIGHTBLUE}${message}${NC}"
  
  # Start deletion in background
  kubectl delete ${resource_type} ${selector} -n ${namespace} --ignore-not-found=true &
  local delete_pid=$!
  
  # Wait for deletion with timeout
  local waited=0
  local check_interval=5
  while kill -0 $delete_pid 2>/dev/null; do
    sleep $check_interval
    waited=$((waited + check_interval))
    
    if [ $waited -ge $timeout ]; then
      echo -e "${YELLOW}WARNING: Deletion of ${resource_type} is taking longer than expected. Continuing in background...${NC}"
      break
    fi
    
    echo -n "."
  done
  echo ""
}

# Remove ingress resources first (to allow ALB to be deleted properly)
echo -e "${LIGHTBLUE}Removing ingress resources...${NC}"
INGRESS_COUNT=$(kubectl get ingress --all-namespaces --no-headers | wc -l)
if [ "$INGRESS_COUNT" -gt 0 ]; then
  echo -e "${LIGHTBLUE}Found ${INGRESS_COUNT} ingress resource(s). Starting deletion...${NC}"
  echo -e "${YELLOW}NOTE: This might take a few minutes as AWS Load Balancer resources need to be cleaned up${NC}"
  
  # Initiate deletion of all ingresses but don't wait indefinitely
  kubectl get ingress --all-namespaces -o json | jq -r '.items[] | "\(.metadata.namespace) \(.metadata.name)"' | \
  while read namespace name; do
    delete_with_timeout "ingress" "$name" "$namespace" 30 "Deleting ingress $name in namespace $namespace"
  done
  
  echo -e "${LIGHTGREEN}✅ Ingress deletion initiated. Proceeding with other cleanup tasks.${NC}"
else
  echo -e "${LIGHTBLUE}No ingress resources found.${NC}"
fi

# Delete all resources created by kustomization
echo -e "${LIGHTBLUE}Removing application resources deployed with kustomize...${NC}"
kubectl delete -k . --ignore-not-found=true --timeout=30s || true
echo -e "${LIGHTGREEN}✅ Application resources removal initiated${NC}"

# Remove application-specific resources (add as needed)
echo -e "${LIGHTBLUE}Removing application-specific resources...${NC}"
# Add any custom resource cleanup here
# Example:
# kubectl delete deployments --all --namespace=default --ignore-not-found=true --timeout=30s || true
# kubectl delete services --all --namespace=default --ignore-not-found=true --timeout=30s || true
echo -e "${LIGHTGREEN}✅ Application resources removal initiated${NC}"

echo -e "${LIGHTBLUE}=========================================================${NC}"
echo -e "${LIGHTGREEN}Application resources cleanup initiated!${NC}"
echo -e "${YELLOW}Note: Some AWS resources might still be in the process of deletion.${NC}"
echo -e "${YELLOW}This is normal and terraform destroy should handle them properly.${NC}"
echo -e "${LIGHTBLUE}You can now run 'terraform destroy' to remove AWS infrastructure${NC}"
echo -e "${LIGHTBLUE}=========================================================${NC}"
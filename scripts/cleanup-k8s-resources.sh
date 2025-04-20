#!/bin/bash

# Cleanup script to remove application resources before running terraform destroy
# This script ensures a clean state before destroying infrastructure

set -e  # Exit on any error

LIGHTBLUE='\033[1;36m'
LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;31m'
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

# Delete all resources created by kustomization
echo -e "${LIGHTBLUE}Removing application resources deployed with kustomize...${NC}"
kubectl delete -k . --ignore-not-found=true || true
echo -e "${LIGHTGREEN}✅ Application resources removed${NC}"

# Remove ingress resources first (to allow ALB to be deleted properly)
echo -e "${LIGHTBLUE}Removing ingress resources...${NC}"
kubectl delete ingress --all --all-namespaces --ignore-not-found=true || true
echo -e "${LIGHTGREEN}✅ Ingress resources removed${NC}"

# Remove application-specific resources (add as needed)
echo -e "${LIGHTBLUE}Removing application-specific resources...${NC}"
# Add any custom resource cleanup here
# Example:
# kubectl delete deployments --all --namespace=default --ignore-not-found=true || true
# kubectl delete services --all --namespace=default --ignore-not-found=true || true
echo -e "${LIGHTGREEN}✅ Application resources removed${NC}"

echo -e "${LIGHTBLUE}=========================================================${NC}"
echo -e "${LIGHTGREEN}Application resources cleanup complete!${NC}"
echo -e "${LIGHTBLUE}You can now run 'terraform destroy' to remove AWS infrastructure${NC}"
echo -e "${LIGHTBLUE}=========================================================${NC}"
#!/bin/bash

# Script to configure kubectl and helm for an EKS cluster
# This script sets up your local environment to connect to your EKS cluster

set -e  # Exit on any error

LIGHTBLUE='\033[1;36m'
LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;31m'
NC='\033[0m' # No Color

# Check for required tools
check_prerequisites() {
  echo -e "${LIGHTBLUE}Checking for required tools...${NC}"
  
  if ! command -v aws &> /dev/null; then
    echo -e "${LIGHTRED}Error: AWS CLI is not installed. Please install it first.${NC}"
    echo "Visit: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    exit 1
  fi
  
  if ! command -v kubectl &> /dev/null; then
    echo -e "${LIGHTRED}Error: kubectl is not installed. Please install it first.${NC}"
    echo "Visit: https://kubernetes.io/docs/tasks/tools/install-kubectl/"
    exit 1
  fi
  
  if ! command -v helm &> /dev/null; then
    echo -e "${LIGHTRED}Error: helm is not installed. Please install it first.${NC}"
    echo "Visit: https://helm.sh/docs/intro/install/"
    exit 1
  fi
  
  # Check AWS CLI configuration
  if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${LIGHTRED}Error: AWS CLI is not configured correctly.${NC}"
    echo "Please run 'aws configure' to set up your AWS credentials."
    exit 1
  fi
  
  echo -e "${LIGHTGREEN}All required tools are installed and configured!${NC}"
}

# Configure kubectl for EKS
configure_kubectl() {
  echo -e "${LIGHTBLUE}Configuring kubectl for EKS...${NC}"
  
  # Attempt to get cluster name from Terraform output or prompt user
  CLUSTER_NAME=""
  AWS_REGION=""
  
  if [ -d "./terraform" ] && command -v terraform &> /dev/null; then
    echo "Attempting to get cluster information from Terraform..."
    cd terraform
    if terraform output cluster_id &> /dev/null; then
      CLUSTER_NAME=$(terraform output -raw cluster_id)
      AWS_REGION=$(terraform output -raw aws_region 2>/dev/null || echo "")
      echo "Found cluster name from Terraform: ${CLUSTER_NAME}"
      cd ..
    else
      echo "Could not find cluster information in Terraform outputs."
      cd ..
    fi
  fi
  
  # If we couldn't get the cluster name from Terraform, prompt the user
  if [ -z "$CLUSTER_NAME" ]; then
    read -p "Enter your EKS cluster name: " CLUSTER_NAME
  fi
  
  if [ -z "$AWS_REGION" ]; then
    AWS_REGION=$(aws configure get region)
    if [ -z "$AWS_REGION" ]; then
      read -p "Enter AWS region: " AWS_REGION
    fi
  fi
  
  echo "Updating kubeconfig for cluster: ${CLUSTER_NAME} in region: ${AWS_REGION}"
  aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${AWS_REGION}
  
  if [ $? -eq 0 ]; then
    echo -e "${LIGHTGREEN}Successfully configured kubectl for EKS cluster: ${CLUSTER_NAME}${NC}"
  else
    echo -e "${LIGHTRED}Failed to configure kubectl. Please check your cluster name and region.${NC}"
    exit 1
  fi
  
  # Verify kubectl configuration
  echo "Verifying kubectl configuration..."
  kubectl get nodes
  
  if [ $? -eq 0 ]; then
    echo -e "${LIGHTGREEN}Successfully connected to the EKS cluster!${NC}"
  else
    echo -e "${LIGHTRED}Could not connect to the EKS cluster. Please check your AWS permissions.${NC}"
    exit 1
  fi
}

# Configure helm
configure_helm() {
  echo -e "${LIGHTBLUE}Configuring Helm...${NC}"
  
  # Add required repositories
  echo "Adding required Helm repositories..."
  helm repo add eks https://aws.github.io/eks-charts 2>/dev/null || true
  helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ 2>/dev/null || true
  helm repo update
  
  echo -e "${LIGHTGREEN}Helm is configured and ready to use!${NC}"
}

# Check permissions for deploying application resources
check_permissions() {
  echo -e "${LIGHTBLUE}Checking permissions for deploying cluster components...${NC}"
  
  # Check cluster-admin access by attempting to list ClusterRoles
  if kubectl get clusterroles &> /dev/null; then
    echo -e "${LIGHTGREEN}You have sufficient permissions to manage cluster-wide resources.${NC}"
  else
    echo -e "${LIGHTRED}Warning: You may not have cluster-admin permissions.${NC}"
    echo "Some cluster configurations might fail. Please ensure you have appropriate RBAC permissions."
  fi
}

# Main function
main() {
  echo -e "${LIGHTBLUE}=========================================================${NC}"
  echo -e "${LIGHTBLUE}    Setting up kubectl and Helm for your EKS cluster${NC}"
  echo -e "${LIGHTBLUE}=========================================================${NC}"
  
  check_prerequisites
  configure_kubectl
  configure_helm
  check_permissions
  
  echo -e "${LIGHTBLUE}=========================================================${NC}"
  echo -e "${LIGHTGREEN}Setup complete!${NC}"
  echo -e "${LIGHTBLUE}=========================================================${NC}"
}

# Run the main function
main
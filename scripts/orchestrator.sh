#!/bin/bash
LIGHTBLUE='\033[1;36m'
LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;31m'
NC='\033[0m'

usage() {
  echo "Usage: $0 [create|start|stop|delete|apply|status]"
  echo " create: Create the Kubernetes cluster"
  echo " start: Start the Kubernetes cluster"
  echo " stop: Stop the Kubernetes cluster"
  echo " delete: Delete the Kubernetes cluster"
  echo " apply: Apply all Kubernetes manifests"
  echo " status: Check the status of the Kubernetes cluster"
  exit 1
}

check_vagrant() {
  if ! command -v vagrant &> /dev/null; then
    echo -e "${LIGHTRED}Vagrant is not installed. Please install Vagrant first.${NC}"
    exit 1
  fi
}

check_kubectl() {
  if ! command -v kubectl &> /dev/null; then
    echo -e "${LIGHTRED}kubectl is not installed. Please install kubectl first.${NC}"
    exit 1
  fi
}

create_cluster() {
  check_vagrant
  echo -e "${LIGHTBLUE}Creating Kubernetes cluster...${NC}"
  vagrant up
  # Copy kubeconfig to local machine
  mkdir -p ~/.kube
  vagrant ssh master -c "sudo cat /etc/rancher/k3s/k3s.yaml" | sed 's/127.0.0.1/192.168.56.10/g' > ~/.kube/k3s-config
  export KUBECONFIG=~/.kube/k3s-config
  echo "To use kubectl with this cluster, run:"
  echo "export KUBECONFIG=~/.kube/k3s-config"
  echo -e "${LIGHTGREEN}Cluster created${NC}"
  
  apply_manifests
}

start_cluster() {
  check_vagrant
  echo -e "${LIGHTBLUE}Starting Kubernetes cluster...${NC}"
  vagrant up
  echo -e "${LIGHTGREEN}Cluster started${NC}"
}

stop_cluster() {
  check_vagrant
  echo -e "${LIGHTBLUE}Stopping Kubernetes cluster...${NC}"
  vagrant halt
  echo -e "${LIGHTGREEN}Cluster stopped${NC}"
}

delete_cluster() {
  check_vagrant
  echo -e "${LIGHTBLUE}Deleting Kubernetes cluster...${NC}"
  vagrant destroy -f
  echo -e "${LIGHTBLUE}Deleting K3s configuration...${NC}"
  rm -rf ~/.kube/k3s-config
  rm -f ./token
  rm -rf ./.vagrant
  echo -e "${LIGHTGREEN}Cluster and configuration deleted${NC}"
}

apply_manifests() {
  check_kubectl
  echo -e "${LIGHTBLUE}Applying Kubernetes manifests...${NC}"
  export KUBECONFIG=~/.kube/k3s-config
  echo "======================================"
    echo -e "${LIGHTBLUE}IMPORTANT: To use kubectl with this cluster, run:${NC}"
    echo "export KUBECONFIG=~/.kube/k3s-config"
    echo -e "${LIGHTBLUE}Or add this line to your ~/.bashrc or ~/.zshrc file for permanent configuration${NC}"
    echo "======================================"
  kubectl apply -k .
  echo -e "${LIGHTGREEN}Manifests applied!${NC}"
}

check_status() {
  check_kubectl
  echo -e "${LIGHTBLUE}Checking Kubernetes cluster status...${NC}"
  echo
  echo -e "${LIGHTBLUE}Nodes:${NC}"
  echo "======================================"
  kubectl get nodes -o wide
  echo ""
  echo -e "${LIGHTBLUE}Pods:${NC}"
  echo "======================================"
  kubectl get pods -A
  echo ""
  echo -e "${LIGHTBLUE}Services:${NC}"
  echo "======================================"
  kubectl get services -A
  echo ""
  echo -e "${LIGHTBLUE}Autoscaling:${NC}"
  echo "======================================"
  kubectl get hpa -A
  echo ""
  echo -e "${LIGHTBLUE}Persistent Volumes:${NC}"
  echo "======================================"
  kubectl get pv,pvc -A
}

case "$1" in
  create)
    create_cluster
    ;;
  start)
    start_cluster
    ;;
  stop)
    stop_cluster
    ;;
  delete)
    delete_cluster
    ;;
  apply)
    apply_manifests
    ;;
  status)
    check_status
    ;;
  *)
    usage
    ;;
esac
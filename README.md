# Cloud Design - Microservices Architecture on AWS

A comprehensive microservices-based application deployed on AWS using containerization, orchestration, and infrastructure as code principles. This project demonstrates a scalable, secure, and monitored cloud architecture for a movie inventory and billing system.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Components](#components)
- [Prerequisites](#prerequisites)
- [Setup and Installation](#setup-and-installation)
- [Infrastructure Management](#infrastructure-management)
- [Security](#security)
- [Monitoring and Logging](#monitoring-and-logging)
- [API Documentation](#api-documentation)
- [Cost Management](#cost-management)
- [Troubleshooting](#troubleshooting)
- [Future Improvements](#future-improvements)

## Architecture Overview

This project implements a microservices architecture deployed on Amazon Web Services (AWS) using Elastic Kubernetes Service (EKS). The system is built to be resilient, scalable, and secure, following cloud-native best practices.

### Architecture Diagram

The architecture follows a multi-availability zone deployment pattern with the following key components:

![Architecture Diagram](architecture-diagram.png)

### Design Decisions

1. **Multi-AZ Deployment**: Services are distributed across two availability zones for high availability and disaster recovery.
2. **Private/Public Subnet Architecture**: All application workloads run in private subnets with controlled access to the internet via NAT gateways.
3. **EKS for Orchestration**: Kubernetes is used to manage containerized workloads for scaling and reliability.
4. **Message Queue for Decoupling**: RabbitMQ acts as a message broker between the API Gateway and Billing service for asynchronous processing.
5. **Infrastructure as Code**: All infrastructure is defined and provisioned using Terraform.

## Components

The application consists of the following microservices:

| Component     | Description                             | Technology      | Port |
| ------------- | --------------------------------------- | --------------- | ---- |
| API Gateway   | Routes requests to appropriate services | Node.js/Express | 3000 |
| Inventory App | Manages movie inventory                 | Node.js/Express | 8080 |
| Inventory DB  | Stores movie data                       | PostgreSQL      | 5432 |
| Billing App   | Processes orders and billing            | Node.js/Express | 8080 |
| Billing DB    | Stores order and billing data           | PostgreSQL      | 5432 |
| Billing Queue | Message broker for order processing     | RabbitMQ        | 5672 |

### Service Interactions

1. Users access the application through the API Gateway
2. Movie inventory requests are directly forwarded to the Inventory App
3. Order requests are sent to the Billing Queue
4. The Billing App consumes messages from the queue and processes orders
5. Each service interacts with its respective database

## Prerequisites

Before setting up this project, ensure you have:

- AWS Account with appropriate permissions
- AWS CLI installed and configured
- Terraform v1.0.0+ installed
- Docker installed
- kubectl installed
- Helm v3+ installed

## Setup and Installation

### 1. AWS Account Setup

Ensure your AWS CLI is configured with appropriate credentials:

```bash
aws configure
```

### 2. Infrastructure Provisioning

Clone this repository:

```bash
git clone <repository-url>
cd cloud-design
```

Bootstrap Terraform backend (run once):

```bash
cd terraform/bootstrap
terraform init
terraform apply
cd ../..
```

Deploy the infrastructure:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 3. Configure kubectl to access your EKS cluster

```bash
./scripts/configure-kubectl-helm.sh
```

### 4. Deploy Kubernetes Resources

Apply Kubernetes manifests:

```bash
kubectl apply -k .  # Apply kustomization
```

### 5. Apply Ingress Configuration

```bash
./scripts/apply-ingress.sh
```

_Note: Docker images are already available in Docker Hub, so there's no need to build and push them._

## Infrastructure Management

### Terraform Modules

The infrastructure is organized into modular components:

- **IAM**: User and role management
- **VPC**: Network configuration
- **EKS**: Kubernetes cluster setup
- **ACM**: Certificate management
- **Kubernetes Addons**: Load balancer controller and metrics server

### Scaling

The application supports autoscaling based on CPU and memory metrics:

- Horizontal Pod Autoscaler (HPA) manages pod scaling
- Node autoscaling is configured through the EKS node group settings
- Current configuration: Min 2 nodes, Max 5 nodes, Desired 2 nodes

### Updating the Infrastructure

To update the infrastructure:

```bash
cd terraform
terraform plan  # Review changes
terraform apply  # Apply changes
```

## Security

The infrastructure implements several security measures:

- **Network Security**:

  - Private subnets for all application components
  - NAT Gateways for controlled outbound access
  - Security Groups for fine-grained access control

- **API Security**:

  - HTTPS termination at the Load Balancer
  - Self-signed certificates through ACM (For production, use verified certificates)

- **Database Security**:

  - Databases only accessible within the VPC
  - No direct public access to database pods
  - Credentials managed securely in Kubernetes Secrets

- **Authentication and Authorization**:
  - AWS IAM roles for service accounts
  - Principles of least privilege applied throughout

## Monitoring and Logging

The system includes the following monitoring components:

- **Metrics Server**: Basic Kubernetes metrics for HPA
- **CloudWatch**: Container logs and metrics
- **Node metrics**: CPU, memory, and network utilization

To view logs:

```bash
kubectl logs -f deployment/api-gateway-app
kubectl logs -f deployment/inventory-app
kubectl logs -f deployment/billing-app
```

## API Documentation

The API Gateway exposes the following endpoints:

- **GET /movies**: Retrieve all movies from inventory
- **GET /movies/:id**: Retrieve a specific movie
- **POST /order**: Create a new order

API specification is available in OpenAPI format at:
`src/api-gateway/openapi.yaml`

## Cost Management

This infrastructure is designed to be cost-effective while maintaining reliability:

- EKS cluster uses t3.medium instances for optimal cost/performance
- Autoscaling ensures resources are only used when needed
- NAT Gateways are shared across services to minimize costs
- DynamoDB and S3 are used for Terraform state with minimal costs

Estimated monthly cost: $150-$200 USD (varies based on usage)

Cost optimization tips:

- Use AWS Cost Explorer to monitor spending
- Implement scheduled scaling for non-production environments
- Consider spot instances for non-critical workloads

## Troubleshooting

Common issues and their solutions:

### Cannot connect to the API Gateway

1. Check the status of ingress: `kubectl get ingress`
2. Verify Load Balancer health checks in AWS Console
3. Check if API Gateway pods are running: `kubectl get pods -l app=api-gateway`

### Database connection issues

1. Check database pods: `kubectl get pods -l app=inventory-db`
2. Verify connection details in environment configuration
3. Check logs: `kubectl logs deploy/inventory-app`

### Clean up resources

If you need to remove all resources:

```bash
./scripts/cleanup-k8s-resources.sh
cd terraform
terraform destroy
```

## Future Improvements

Potential enhancements for this architecture:

1. Implement AWS Cognito for user authentication
2. Add Prometheus and Grafana for advanced monitoring
3. Implement GitOps with ArgoCD for continuous deployment
4. Add distributed tracing with AWS X-Ray or Jaeger
5. Implement database backups and disaster recovery procedures

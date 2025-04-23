### What is the cloud and its associated benefits?

Cloud computing provides on-demand delivery of IT resources over the internet with pay-as-you-go pricing. The key benefits include:

- **Scalability**: Ability to scale resources up or down based on demand
- **Cost Efficiency**: No upfront infrastructure investment; pay only for what you use
- **Global Reach**: Deploy applications anywhere in the world within minutes
- **Agility**: Rapid development, testing, and deployment of applications
- **Reliability**: Redundant systems across multiple availability zones and regions
- **Security**: Advanced security features and compliance certifications

### Why is deploying the solution in the cloud preferred over on-premises?

1. **Reduced Capital Expenditure**: No need to purchase and maintain expensive hardware
2. **Faster Time to Market**: Provision resources in minutes instead of weeks or months
3. **Operational Efficiency**: Managed services reduce administrative burden
4. **Built-in High Availability**: Multi-AZ and region deployments for resilience
5. **Automatic Updates and Maintenance**: Infrastructure managed by the cloud provider
6. **Elastic Resource Allocation**: Scale resources based on actual demand patterns

### How would you differentiate between public, private, and hybrid cloud?

**Public Cloud**:

- Resources owned and operated by third-party providers (AWS, Azure, GCP)
- Accessible over the internet
- Pay-as-you-go model

**Private Cloud**:

- Dedicated resources for a single organization
- Greater control over security and compliance
- Can be hosted on-premises or by a third party
- Higher cost but more customization options

**Hybrid Cloud**:

- Combination of public and private cloud resources
- Workloads can move between environments as needed
- Balance between control and cost-efficiency
- Useful for organizations with varying workload requirements

### What drove your decision to select AWS for this project, and what factors did you consider?

AWS was required for this project. AWS is also the most popular cloud platform.

### Can you describe your microservices application's AWS-based architecture and the interaction between its components?

Our architecture consists of multiple interconnected components deployed across a secure multi-AZ AWS infrastructure:

**Infrastructure Layer**:

- **VPC (10.0.0.0/16)** spanning two availability zones (eu-north-1a, eu-north-1b)
- **Public Subnets** (10.0.1.0/24, 10.0.2.0/24) for NAT Gateways and ingress
- **Private Subnets** (10.0.11.0/24, 10.0.12.0/24) for EKS worker nodes and application pods
- **Internet Gateway** for public internet access
- **NAT Gateways** in each AZ for outbound connectivity from private subnets
- **Application Load Balancer** for routing external traffic to services

**Compute Layer**:

- **Amazon EKS** (Managed Kubernetes) for container orchestration
- **EKS Node Groups** deployed in private subnets for security
- **Auto-scaling Groups** to handle varying workloads

**Application Components**:

1. **API Gateway Service** (Node.js/Express):

   - Entry point for all client requests
   - Routes requests to appropriate backend services
   - Provides API documentation via Swagger/OpenAPI
   - Scales horizontally (1-3 replicas based on CPU utilization)

2. **Inventory Service** (Node.js/Express):

   - Manages movie catalog data with CRUD operations
   - Connected to PostgreSQL database
   - Scales horizontally (1-3 replicas based on CPU utilization)

3. **Billing Service** (Node.js/Express):

   - Processes order requests asynchronously
   - Connected to PostgreSQL database
   - Consumes messages from RabbitMQ queue

4. **Data Stores**:
   - **PostgreSQL Databases** (inventory-db, billing-db) for persistent storage
   - **RabbitMQ** message queue for asynchronous communication

**Interaction Flow**:

1. External requests arrive at the Application Load Balancer
2. ALB routes traffic to the API Gateway service
3. API Gateway routes requests to appropriate services:
   - Movie-related requests → Inventory Service
   - Order requests → Messages sent to RabbitMQ queue
4. Billing Service consumes messages from the queue and processes orders
5. Each service interacts with its dedicated database for data persistence

### How did you manage and optimize the cost of your AWS solution?

Used `Amazon Free Tier` in the beginning to set up the main infrastructure. Teted Kubernetes/Helm overhead on `t3.micro` instance. After that switched to `t3.medium` instance to run every single pod required for the minimum workload. Finally used `t3.large` instance to fit all the pods required on maximum load.

### What measures did you implement to ensure application security on AWS, and what AWS security best practices did you adhere to?

Security was implemented at multiple layers throughout the architecture:

**Network Security**:

- **VPC Isolation**: Resources deployed in private subnets
- **Security Groups**: Restrictive inbound/outbound rules
- **Network ACLs**: Additional network traffic filtering
- **Private EKS Endpoint**: Cluster API server accessible only within VPC

**Access Control**:

- **IAM Roles and Policies**: Least privilege principle
- **IAM Role for Service Accounts (IRSA)**: Granular permissions for Kubernetes workloads
- **EKS RBAC**: Role-based access control within Kubernetes
- **Separate IAM roles** for different infrastructure components

**Data Security**:

- **Secrets Management**: Kubernetes Secrets for sensitive configuration
- **TLS Termination**: HTTPS for all external traffic
- **Database Credentials Isolation**: Each service has access only to its database

**Infrastructure Security**:

- **Private Worker Nodes**: EKS nodes in private subnets
- **Container Security**: Non-root users in containers
- **Regular Updates**: Latest Amazon EKS and Kubernetes versions

**Security Best Practices**:

- Principle of least privilege for all IAM policies
- Network traffic isolation between different application tiers
- Encryption in transit using HTTPS/TLS
- Container image security scanning (planned enhancement)
- Regular security patches and updates

**AWS Security Services**:

- **AWS Certificate Manager**: For TLS certificate management
- **AWS IAM**: For identity and permission management

### What AWS monitoring and logging tools did you utilize, and how did they assist in identifying and troubleshooting application issues?

Implemented comprehensive monitoring and logging using multiple AWS tools:

**CloudWatch Monitoring**:

- **Custom CloudWatch Dashboard**: Comprehensive visualization of cluster performance
- **Container Insights**: Deep visibility into container performance metrics

**Dashboard Organization**:

- **Overall Cluster Health**: Aggregate metrics across the cluster
- **Namespace Monitoring**: Metrics segmented by Kubernetes namespaces
- **Pod-specific Panels**: Dedicated metrics for each microservice

### Can you describe the AWS auto-scaling policies you implemented and how they help your application accommodate varying workloads?

**Pod-level Auto-scaling**:

- **Horizontal Pod Autoscaler (HPA)** implemented for stateless services:
  - API Gateway: 1-3 replicas based on 60% CPU utilization
  - Inventory Service: 1-3 replicas based on 60% CPU utilization
- **Benefits**:
  - Rapid scaling in response to traffic spikes (typically within 1-2 minutes)
  - Resource efficiency during low-demand periods
  - Independent scaling of services based on their specific workloads

**Node-level Auto-scaling**:

- **EKS Node Groups** configured with auto-scaling properties:
  - Minimum size: 1 node per AZ
  - Maximum size: 2 nodes per AZ
  - Desired capacity: Managed by Cluster Autoscaler
- **Cluster Autoscaler** deployed to automatically adjust node count based on pod scheduling demands
- **Benefits**:
  - Infrastructure scales with application demands
  - Cost optimization by removing underutilized nodes
  - Automated handling of node failures

**Traffic Distribution**:

- **Application Load Balancer** configured to:
  - Distribute traffic across multiple pods
  - Perform health checks to route only to healthy instances
  - Balance load across availability zones
- **Benefits**:
  - Even distribution of incoming requests
  - Automatic removal of unhealthy endpoints
  - Smooth handling of traffic spikes

**Real-world Workload Accommodation**:

1. **Normal Operation**: Minimum pods running (1 per service)
2. **Traffic Increase**: HPA adds pods as CPU utilization increases
3. **Resource Shortage**: If additional pods can't be scheduled, Cluster Autoscaler provisions new nodes
4. **Traffic Decrease**: As load reduces, HPA scales down pods
5. **Underutilization**: After sufficient time with fewer pods, Cluster Autoscaler removes excess nodes

## Docker and Container Implementation

### How did you optimize Docker images for each microservice, and how did it influence build times and image sizes?

**Base Image Selection**:

- Used Node.js Alpine images (node:18-alpine3.21) for all services
- Benefits: ~70% smaller than standard Node.js images (≈50MB vs 170MB)
- Impact: Faster downloads, reduced storage costs, smaller attack surface

**Layer Optimization**:

- Ordered Dockerfile instructions to maximize cache utilization:
  1. Copy package.json and package-lock.json first
  2. Run npm install for dependencies
  3. Copy application code last (most frequently changed)
- Impact: Subsequent builds typically 80% faster due to caching

### If you had to redo this project, what modifications would you make to your approach or the technologies you used?

If redesigning this project, I would make several strategic improvements:

1. **API Gateway Service**: Replace custom Node.js gateway with Amazon API Gateway for managed authentication, throttling, and caching

2. **Amazon RDS**: Use managed RDS instead of self-managed PostgreSQL for better reliability and automatic backups
3. **Amazon MQ**: Replace self-managed RabbitMQ with Amazon MQ for managed message broker service

4. **AWS Secrets Manager**: Use instead of Kubernetes Secrets for better rotation and audit capabilities
5. **AWS WAF**: Implement web application firewall for improved protection against common exploits

### How can your AWS solution be expanded or altered to cater to future requirements like adding new microservices or migrating to a different cloud provider?

The architecture was designed with future expansion and potential cloud migration in mind:

**Expanding with New Microservices**:

1. **Modular Infrastructure**:

   - Terraform modules are organized to easily accommodate new services
   - Kubernetes manifests follow consistent patterns that can be templated for new services
   - Shared infrastructure components (VPC, EKS) already sized for growth

2. **Integration Points**:

   - API Gateway designed as an extensible entry point
   - Service discovery via Kubernetes enables new services to be discovered automatically
   - Message queue system allows for easy addition of new producers or consumers

3. **Scaling Considerations**:
   - Auto-scaling configurations can be replicated for new services
   - Resource quotas and limits defined at namespace level can be adjusted
   - Multi-AZ deployment strategy applies to new components

**Process for Adding a New Microservice**:

1. Develop the service following existing patterns
2. Create Dockerfile and Kubernetes manifests based on templates
3. Add service-specific Terraform resources if needed
4. Update API Gateway routes to include new service endpoints
5. Deploy using existing pipeline and monitoring

### What challenges did you face during the project and how did you address them?

- The first challenge was setting up different permissions to access AWS cloud environment. It's quite a difficult system to grasp in the beginning.

- The second challenge was to get the Cloudwatch working. In the beginning I tried `eks-charts` and `fluentd`, but couldn't get it to working. Kept running into some authentication error. Then tried Cloudwatch Observability Addon and got it working.

### How did you ensure your documentation's clarity and completeness, and what measures did you take to make it easily understandable and maintainable?

I tried to just include information and instructions required for the `cloud-design` project and leave out local development information, which I will add in the final project after I've fully completed the application, cloud infrastructure and CI/CD.

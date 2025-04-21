variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to use in eu-north-1"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "cloud-design-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "node_instance_types" {
  description = "List of instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  type        = string
  default     = "SPOT"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

# Certificate Manager variables - simplified for self-signed certificate
variable "certificate_common_name" {
  description = "Common name for the self-signed certificate (can be any value for demo)"
  type        = string
  default     = "cloudproject.example.com"
}

variable "cli_admin_username" {
  description = "Username of the CLI admin user that needs AWS permissions"
  type        = string
  default     = "cli-admin"
}

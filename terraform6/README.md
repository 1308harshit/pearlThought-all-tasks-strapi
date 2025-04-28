# Deploy Strapi on AWS ECS Fargate with Terraform and GitHub Actions CI/CD

This directory contains Terraform configurations and CI/CD workflows for deploying a **Strapi CMS** application on **AWS ECS Fargate**. The setup also includes monitoring and logging using **CloudWatch**. The process is fully automated using **GitHub Actions** for building, pushing the image to **Amazon ECR**, and deploying the app on ECS Fargate.

The deployment includes:

- **Containerizing** the Strapi application using **Docker**.
- **Pushing** the Docker image to **Amazon Elastic Container Registry (ECR)**.
- **Provisioning AWS Infrastructure** with **Terraform** for ECS Fargate deployment.
- **CI/CD Automation** using GitHub Actions.
- **CloudWatch Integration** for logging, metrics, and monitoring.

## Overview

This setup deploys a **Strapi CMS** application on **AWS ECS Fargate** using **Terraform**, **Docker**, **Amazon ECR**, and **CloudWatch**. The deployment is fully automated, including:

- **Building and pushing Docker images** to Amazon ECR using GitHub Actions.
- **Provisioning infrastructure** (VPC, ECS cluster, load balancer) with Terraform.
- **CloudWatch monitoring** for ECS container logs, CPU/Memory metrics, task count, and network metrics.
- **CloudWatch Alarms** for high resource usage and application health monitoring.

## Folder Structure

```
terraform5/
├── ecs.yml                  # GitHub Actions workflow for ECS deployment
├── ecr.yml                  # GitHub Actions workflow for building and pushing Docker image to ECR
├── main.tf                  # Terraform configuration for ECS and related AWS resources
├── variables.tf             # Terraform variables for configuration
├── outputs.tf               # Outputs for ECS deployment, ALB URL
├── provider.tf              # AWS provider configuration
├── security_group.tf        # Security group configuration
├── vpc.tf                   # VPC, subnets, IGW, and route table configuration
└── README.md                # This file
```

## Secrets

The following secrets are required for the CI/CD automation and Terraform configuration:

1. **`AWS_ACCESS_KEY_ID`** – AWS access key for configuring AWS credentials.
2. **`AWS_SECRET_ACCESS_KEY`** – AWS secret access key for configuring AWS credentials.
3. **`AWS_REGION`** – AWS region (e.g., `us-east-1`).
4. **`ECR_REPOSITORY_URI`** – URI of the Amazon ECR repository.
5. **`IMAGE_URI`** – URI of the Docker image.
6. **`AMI_ID`** – AMI ID for EC2 instances (used in Terraform).
7. **`INSTANCE_TYPE`** – EC2 instance type (used in Terraform).
8. **`KEY_NAME`** – EC2 key pair name for SSH access.

Ensure these secrets are configured in your GitHub repository under **Settings > Secrets**.

## Workflows

### 1. **Build and Push Docker Image to ECR (ecr.yml)**
- **Trigger**: Automatically triggered on `push` to the `main` branch.
- **Purpose**: Builds the Docker image for the Strapi app and pushes it to **Amazon ECR**.
- **Key Secrets**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `ECR_REPOSITORY_URI`.
- **Steps**:
  - Checkout code.
  - Configure AWS credentials.
  - Log in to Amazon ECR.
  - Build Docker image.
  - Push Docker image to ECR.

### 2. **Deploy Strapi on ECS with Terraform (ecs.yml)**
- **Trigger**: Manually triggered via `workflow_dispatch`.
- **Purpose**: Deploys the Strapi CMS application on **AWS ECS Fargate** using **Terraform** configurations from this folder.
- **Key Secrets**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `ECR_REPOSITORY_URI`, `IMAGE_URI`.
- **Steps**:
  - Checkout code.
  - Install Terraform.
  - Configure AWS credentials.
  - Initialize Terraform.
  - Generate Terraform plan and apply it to create VPC, ECS Cluster, ALB, and related infrastructure.
  - Deploy Strapi on ECS Fargate.

## Secrets

The following secrets are required for the CI/CD automation and Terraform configuration:

1. **`AWS_ACCESS_KEY_ID`** – AWS access key for configuring AWS credentials.
2. **`AWS_SECRET_ACCESS_KEY`** – AWS secret access key for configuring AWS credentials.
3. **`AWS_REGION`** – AWS region (e.g., `us-east-1`).
4. **`ECR_REPOSITORY_URI`** – URI of the Amazon ECR repository.
5. **`IMAGE_URI`** – URI of the Docker image.
6. **`AMI_ID`** – AMI ID for EC2 instances (used in Terraform).
7. **`INSTANCE_TYPE`** – EC2 instance type (used in Terraform).
8. **`KEY_NAME`** – EC2 key pair name for SSH access.

Ensure these secrets are configured in your GitHub repository under **Settings > Secrets**.

## Workflows

### 1. **Build and Push Docker Image to ECR (ecr.yml)**
- **Trigger**: Automatically triggered on `push` to the `main` branch.
- **Purpose**: Builds the Docker image for the Strapi app and pushes it to **Amazon ECR**.
- **Key Secrets**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `ECR_REPOSITORY_URI`.
- **Steps**:
  - Checkout code.
  - Configure AWS credentials.
  - Log in to Amazon ECR.
  - Build Docker image.
  - Push Docker image to ECR.

### 2. **Deploy Strapi on ECS with Terraform (ecs.yml)**
- **Trigger**: Manually triggered via `workflow_dispatch`.
- **Purpose**: Deploys the Strapi CMS application on **AWS ECS Fargate** using **Terraform** configurations from this folder.
- **Key Secrets**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `ECR_REPOSITORY_URI`, `IMAGE_URI`.
- **Steps**:
  - Checkout code.
  - Install Terraform.
  - Configure AWS credentials.
  - Initialize Terraform.
  - Generate Terraform plan and apply it to create VPC, ECS Cluster, ALB, and related infrastructure.
  - Deploy Strapi on ECS Fargate.

## Terraform Configuration

### `main.tf`
This file contains the Terraform code to deploy AWS resources such as:

- **VPC**, **Subnets**, **Internet Gateway (IGW)**, and **Route Tables**.
- **ECS Cluster** and **Fargate Service**.
- **ECS Task Definition** using the Docker image from ECR.
- **Security Group** and **Application Load Balancer (ALB)**.
- **CloudWatch Log Group** and ECS task logging using the `awslogs` driver.
- **CloudWatch Metrics** for ECS (CPU, Memory, Task Count, Network In/Out).
- **CloudWatch Alarms** for high CPU and memory usage, task health checks, and application latency.

### `variables.tf`
Defines the following variables for customizing the ECS and AWS resources:

- `vpc_cidr_block`: CIDR block for the VPC.
- `subnet_cidr_blocks`: CIDR blocks for the subnets.
- `ecs_cluster_name`: Name of the ECS Cluster.
- `image_uri`: Docker image URI for the Strapi application (from ECR).
- `instance_type`: Type of EC2 instance for Fargate tasks.

### `outputs.tf`
Outputs include:

- `alb_url`: Public URL of the ALB to access the deployed Strapi application.
- `ecs_cluster_name`: Name of the ECS Cluster.
- `cloudwatch_log_group`: CloudWatch Log Group for ECS logs.

### `security_group.tf`
This file defines the **Security Group** rules to allow traffic on HTTP (port 80) and HTTPS (port 443).

### `vpc.tf`
This file provisions the **VPC**, **subnets**, **Internet Gateway**, and **Route Tables** to set up the network infrastructure for ECS and the ALB.

## CloudWatch Integration

### CloudWatch Log Group
A **CloudWatch Log Group** is created in Terraform (e.g., `/ecs/strapi`) to collect logs from ECS tasks. The ECS task definition is configured to use the `awslogs` log driver with the stream prefix `ecs/strapi`.

### CloudWatch Metrics
The following ECS metrics are enabled in CloudWatch:

- **CPUUtilization**: CPU usage of ECS tasks.
- **MemoryUtilization**: Memory usage of ECS tasks.
- **TaskCount**: The number of running tasks in ECS.
- **NetworkIn / NetworkOut**: Network traffic into and out of ECS tasks.

### CloudWatch Alarms
You can optionally create CloudWatch Alarms for:

- **High CPU or Memory Usage**: Alarm triggered if CPU or memory usage exceeds a threshold.
- **Task Health Checks**: Alarm for task health check failures.
- **Application Response Latency**: Alarm for high response latency, if monitored.

## Deployment Steps

### 1. **Set up AWS Credentials**
Ensure that your AWS credentials are correctly configured with `aws configure`.

### 2. **Initialize Terraform**
Run the following command to initialize Terraform and download the necessary provider plugins:
```bash
terraform init
```

### 3. **Plan the Infrastructure**
Preview the infrastructure changes by running:
```bash
terraform plan
```

### 4. **Apply Terraform Configuration**
Deploy the infrastructure with the following command:
```bash
terraform apply
```
Confirm the changes by typing `yes` when prompted.

### 5. **Access Strapi**
Once the ECS Fargate deployment is successful, the public URL of the Application Load Balancer (ALB) will be output. Open this URL in a browser to access your Strapi CMS application.

## Clean Up

To destroy the deployed infrastructure, run the following command:
```bash
terraform destroy
```
When prompted, type `yes` to confirm the destruction of resources.

## Troubleshooting

- If you face issues with ECS tasks not starting, ensure the ECS task has sufficient resources and the Docker image is correctly pushed to ECR.
- Check the security group settings to ensure ports 80 and 443 are open for the ALB.
- Make sure that the ECR image URI is correctly referenced in the Terraform task definition.
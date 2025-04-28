
# Deploy Strapi on AWS ECS Fargate with Terraform

This directory contains Terraform configurations and CI/CD workflows for deploying a **Strapi CMS** application on **AWS ECS Fargate**. The setup involves:

- **Containerizing** the Strapi application using **Docker**.
- **Pushing** the Docker image to **Amazon Elastic Container Registry (ECR)**.
- **Provisioning AWS Infrastructure** with **Terraform** for ECS Fargate deployment.
- **CI/CD Automation** using GitHub Actions for building, pushing the image to ECR, and deploying the app on ECS.

## Overview

This setup deploys a **Strapi CMS** application on **AWS ECS Fargate** using **Terraform**, **Docker**, and **Amazon ECR**. The deployment is fully automated, including the building and pushing of Docker images to ECR and the deployment of Strapi on ECS Fargate with an Application Load Balancer (ALB).

The components include:

- **ECR** for storing Docker images.
- **VPC** with subnets, internet gateway, and route tables.
- **ECS Cluster** with ECS Task Definitions and ECS Service for Fargate.
- **Security Group** and **ALB** for load balancing.

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

## Terraform Configuration

### `main.tf`
This file contains the Terraform code to deploy AWS resources such as:

- **VPC**, **Subnets**, **Internet Gateway (IGW)**, and **Route Tables**.
- **ECS Cluster** and **Fargate Service**.
- **ECS Task Definition** using the Docker image from ECR.
- **Security Group** and **Application Load Balancer (ALB)**.

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

### `security_group.tf`
This file defines the **Security Group** rules to allow traffic on HTTP (port 80) and HTTPS (port 443).

### `vpc.tf`
This file provisions the **VPC**, **subnets**, **Internet Gateway**, and **Route Tables** to set up the network infrastructure for ECS and the ALB.

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


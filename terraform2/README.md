# Strapi Deployment on EC2 with GitHub Actions + Terraform

This project automates the deployment of a **Strapi** application on an **EC2 instance** using **GitHub Actions** for CI/CD, **Terraform** for infrastructure provisioning, and **Docker** for containerization.

### Overview

- **CI/CD Automation**: 
  - **CI Pipeline**: Automatically builds and pushes the Docker image of the Strapi app to Docker Hub or Amazon ECR on code push to the `main` branch.
  - **CD Pipeline**: A manually triggered GitHub Action that runs Terraform to deploy the updated Docker image on an EC2 instance.
  
- **Deployment**: 
  - The EC2 instance runs the Strapi app in a Docker container, accessible via its public IP.

### Workflow Breakdown

1. **CI Pipeline (Continuous Integration)**:
   - Triggered on push to `main` branch.
   - Builds the Docker image for Strapi and pushes it to Docker Hub or ECR.
   - Outputs the Docker image tag for use in the CD pipeline.

2. **CD Pipeline (Continuous Deployment)**:
   - Triggered manually via GitHub Actions.
   - Runs Terraform to provision the EC2 instance and deploy the Strapi Docker container using the image tag from the CI pipeline.

### GitHub Actions Workflow Files

#### **1. CI Workflow - `.github/workflows/ci.yml`**

This file automates the process of building and pushing the Docker image to Docker Hub or ECR on every push to `main` branch.

#### **2. CD Workflow - `.github/workflows/terraform.yml`**

This file is used to manually trigger Terraform to provision infrastructure on AWS (EC2) and deploy the Strapi app using the Docker image tag created in the CI pipeline.

## Terraform Infrastructure Setup

### Key Terraform Files

- **`main.tf`**: Defines the EC2 instance resource and uses the Docker image to run Strapi on EC2.
- **`variables.tf`**: Contains the input variables such as AWS region, AMI ID, and Docker image tag.
- **`outputs.tf`**: Outputs the public IP of the EC2 instance.

### How It Works

#### CI Pipeline:
- When you push changes to the `main` branch, GitHub Actions builds and pushes the Docker image to Docker Hub or ECR.
- The image tag is saved as a GitHub Action output.

#### CD Pipeline:
- You manually trigger the CD pipeline from GitHub Actions.
- Terraform uses the image tag to deploy the Docker container on the EC2 instance.

#### Verification:
- After Terraform applies the changes, the EC2 instance will be running the Strapi app.
- You can verify the deployment by accessing the EC2 instance's public IP.

### Prerequisites

- **AWS Account**: Must have IAM access for EC2, ECR, and other necessary services.
- **Docker Hub or Amazon ECR Account**: For storing the Docker images.
- **GitHub Secrets**:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_REGION`
  - `DOCKERHUB_USERNAME`
  - `DOCKERHUB_PASSWORD`

### Conclusion
This setup allows for seamless automation of the Strapi app deployment using Docker, GitHub Actions, and Terraform, providing an efficient and repeatable process for managing your infrastructure and app deployment.

### Loom Video

https://www.loom.com/share/6a367bebc43d405d888bf13e445dcfc6?sid=f02cefc3-287d-45b1-ba54-45680a7e9a1f
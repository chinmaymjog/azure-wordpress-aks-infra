# Terraform Azure Kubernetes Service (AKS) Deployment

## Project Overview

This repository provides a comprehensive solution for deploying a secure, multi-environment Azure Kubernetes Service (AKS) infrastructure using Terraform and Bash. It follows a hub-and-spoke network topology to centralize shared services and provide network isolation for different environments (e.g., lab, dev, prod).

The key features include:

- **Hub-and-Spoke Architecture**: Centralized hub for shared resources like Azure Container Registry (ACR), Key Vault, and Log Analytics.
- **Multi-Environment Deployment**: Easily deploy multiple, isolated AKS clusters (spokes) for different environments.
- **Declarative Infrastructure**: Uses Terraform to manage all Azure resources declaratively.
- **Automated Deployment**: A `deploy.sh` script automates the entire deployment process, from bootstrapping the Terraform backend to planning and applying changes.
- **Kubernetes Add-ons**: Automatically deploys essential Kubernetes services like NGINX Ingress Controller and Cert-Manager via Helm.

---

## Architecture

This project implements a Hub-and-Spoke model in Azure.

- **Hub**: The central `hub` virtual network contains shared resources that can be accessed by all environments. This includes:
  - Azure Container Registry (ACR)
  - Azure Key Vault
  - Log Analytics Workspace
  - Private DNS Zones
- **Spokes**: Each environment (e.g., `lab-weu`, `prod-neu`) is deployed as a spoke. A spoke consists of its own virtual network, peered to the hub, containing an AKS cluster and its related resources. This ensures network isolation between environments.

**Architecture Diagram:**

_(A diagram illustrating the hub VNet with shared resources and two spoke VNets, each with an AKS cluster, peered to the hub would be ideal here.)_

---

## Prerequisites

- A Linux or macOS environment.
- Terraform (v1.3.x or later).
- Azure CLI.
- An Azure Subscription.
- An Azure Service Principal with `Contributor` permissions on the subscription.

---

## Project Structure

```
.
├── .env.example          # Example environment file for credentials
├── .gitlab-ci.yml        # GitLab CI/CD pipeline configuration
├── deploy.sh             # Main deployment script
├── global_variables      # Global shell variables for all environments
├── aks/                  # Terraform configuration for AKS spokes
│   ├── main.tf
│   ├── variables.tf
│   └── aks-lab-weu-terraform.tfvars
├── database/             # Terraform configuration for Database spokes
│   ├── main.tf
│   ├── variables.tf
│   └── db-lab-weu-terraform.tfvars
├── hub/                  # Terraform configuration for the central Hub
│   ├── main.tf
│   ├── variables.tf
│   └── shared-hub-weu-terraform.tfvars
└── modules/              # Reusable Terraform modules
    ├── aks/
    ├── database/
    └── hub/
```

---

## Getting Started

Follow these steps to configure and deploy the infrastructure.

### 1. Clone the Repository

```bash
git clone <repository-url>
cd terraform-azure-kubernetes
```

### 2. Configure Credentials

Create a `.env` file by copying the example file. This file will store your Azure Service Principal credentials. **This file is git-ignored and should never be committed to source control.**

```bash
cp .env.example .env
```

Now, edit `.env` and fill in your Azure credentials:

```bash
# .env
export ARM_CLIENT_ID="<your-service-principal-app-id>"
export ARM_CLIENT_SECRET="<your-service-principal-password>"
export ARM_TENANT_ID="<your-azure-tenant-id>"
export ARM_SUBSCRIPTION_ID="<your-azure-subscription-id>"
```

### 3. Configure Global Variables

The `global_variables` file contains settings that are shared across all environments, such as the project name, Kubernetes version, and Helm chart versions. Review and adjust these variables as needed.

### 4. Configure Environment-Specific Variables

Each component (`hub`, `aks`, `database`) has its own directory with `.tfvars` files for environment-specific configurations.

- **Hub**: Edit `hub/shared-hub-weu-terraform.tfvars` to configure the hub network.
- **AKS**: For each new AKS environment, copy an existing file (e.g., `aks/aks-lab-weu-terraform.tfvars`) and modify it. The naming convention is `aks-<env>-<location_short>-terraform.tfvars`.
- **Database**: Follow the same pattern for database deployments.

---

## How to Deploy

The `deploy.sh` script is the primary tool for deploying the infrastructure. It handles logging into Azure, bootstrapping the Terraform backend, and running Terraform commands in the correct order.

### Plan Changes

To see what changes Terraform will make without actually applying them, run a `plan`. This is the default action if none is specified.

```bash
# This will run 'terraform plan' for the hub, then for all spokes
./deploy.sh plan
```

### Apply Changes

To create or update the infrastructure, use the `apply` argument. This will run `terraform apply -auto-approve`.

```bash
# This will run 'terraform apply' for all components
./deploy.sh apply
```

The script will first deploy the `hub` resources. It then reads the outputs from the hub (like the Key Vault ID and ACR name) and uses them to deploy the `aks` and `database` spokes defined in the script.

---

## What's Next?

This project provides a solid foundation. Here are some potential next steps and improvements:

- **Automate Role Assignments**: The `AcrPull` role for the AKS-managed identity is a critical step. This can be automated within the `modules/aks/aks_identity.tf` file by uncommenting and adjusting the `azurerm_role_assignment` resource.
- **Add Monitoring and Alerting**: Integrate Azure Monitor alerts for key metrics on AKS and other resources.
- **Implement Security Scanning**: Integrate tools like Trivy or Azure Defender for Cloud to scan container images for vulnerabilities.
- **CI/CD Enhancement**: Further refine the `.gitlab-ci.yml` pipeline to trigger deployments automatically on merges to specific branches or on new tags.

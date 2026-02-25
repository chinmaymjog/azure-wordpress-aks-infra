# 🏗️ Azure WordPress Stack: Tier 1 - Infrastructure

> **Part 1 of the Azure WordPress Stack ecosystem.**

This repository provides an enterprise-grade Infrastructure-as-Code (IaC) solution for deploying a secure, multi-environment Azure Kubernetes Service (AKS) infrastructure. It is the foundational layer for hosting WordPress.

## 🔗 Project Ecosystem Navigation

You are currently at **Step 1: Infrastructure**.

* **Next Step:** [Step 2: Base Docker Image (azure-wp-stack-docker-base)](https://github.com/chinmaymjog/azure-wp-stack-docker-base) - Build the optimized PHP/Nginx base image.
* **Full Ecosystem:**
  * 1️⃣ **Infrastructure** (You are here)
  * 2️⃣ [Base Docker Image](https://github.com/chinmaymjog/azure-wp-stack-docker-base)
  * 3️⃣ [Static Assets (Themes & Plugins)](https://github.com/chinmaymjog/azure-wp-stack-static-assets)
  * 4️⃣ [Helm Chart Deployment & App Boilerplate](https://github.com/chinmaymjog/azure-wp-stack-helm-chart)

---

## 🚀 Key Features

- **Hub-and-Spoke Architecture**: Centralized hub for shared resources (ACR, Key Vault, Log Analytics) with VNet peering to spoke environments.
- **Multi-Environment Ready**: Easily deploy isolated AKS clusters for Lab, Staging, and Production.
- **Automated Bootstrap**: A `deploy.sh` script automates the Terraform backend setup and execution order.
- **Pre-configured Add-ons**: Built-in support for NGINX Ingress, Cert-Manager, and Kured via modular Helm deployments.

---

## 🏗️ Architecture

This project implements a Hub-and-Spoke model in Azure:

- **Hub**: Contains shared infrastructure like the Private DNS zones, ACR, and global logging.
- **Spokes**: Each spoke (e.g., `aks-lab-weu`) is an isolated VNet containing its own AKS cluster, peered to the hub for shared service access.

---

## 🛠️ Project Structure

```text
.
├── deploy.sh             # Main deployment automation engine
├── global_variables      # Global settings (project names, versions)
├── aks/                  # Spoke configuration for AKS clusters
├── hub/                  # Central hub infrastructure
├── modules/              # Reusable Terraform modules (AKS, Hub, Database)
└── .github/              # GitHub Actions for automated verification
```

---

## 🏁 Getting Started

### 1. Prerequisites
- Terraform (v1.3.x+)
- Azure CLI
- Azure Service Principal with `Contributor` rights.

### 2. Configure Credentials
Create a `.env` file (git-ignored) with your Azure details:
```bash
export ARM_CLIENT_ID="<your-app-id>"
export ARM_CLIENT_SECRET="<your-password>"
export ARM_TENANT_ID="<your-tenant-id>"
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
```

### 3. Deploy Infrastructure
The `deploy.sh` script handles the complexity of state management and variable injection.

```bash
# Plan the entire infrastructure
./deploy.sh plan

# Apply changes to all components
./deploy.sh apply
```

---

## 🛡️ License
Distributed under the MIT License. See `LICENSE` for more information.

# Enterprise Azure Kubernetes (AKS) Platform

This repository provides an enterprise-grade solution for deploying a secure, multi-environment Azure Kubernetes Service (AKS) infrastructure using Terraform and Bash. It follows a **Hub-and-Spoke** network topology to centralize shared services (like Container Registries and Key Vaults) and provides network isolation for spokes (dev, prod).

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

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
- **Pre-configured Add-ons**: The infrastructure deployed focuses cleanly on Azure resources. Ingress (NGINX), Cert-Manager, and Kured are designed to be deployed optionally as post-infrastructure steps.

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
The `deploy.sh` script handles the complexity of state management, cross-module variable injection (Hub to AKS), and environment switching.

You can explicitly deploy to different environments (`lab`, `dev`, `preprod`, `prod`) by passing the environment argument.

```bash
# Example: Plan the Hub (Shared resources)
./deploy.sh hub plan

# Example: Apply the Hub
./deploy.sh hub apply

# Example: Plan the AKS cluster for a specific environment (e.g., dev)
./deploy.sh aks plan dev weu

# Example: Apply the AKS cluster to the dev environment
./deploy.sh aks apply dev weu
```

### 4. Scaling for Production Workloads
> [!NOTE]
> **Cost-Effective Testing Defaults:** To minimize Azure costs during initial testing and deployment validation, **all included environment templates** (including `prod` and `preprod`) have been purposely downscaled to use minimal compute tiers (e.g., `Standard_B2ms` nodes, `B_Standard_B1ms` databases, `Standard` storage).

If you are preparing to deploy this stack for a true production-grade environment, you **must** modify the environment-specific `.tfvars` files (like `aks/aks-prod-<region>-terraform.tfvars` and `database/database-prod-terraform.tfvars`) to ensure adequate scaling:

- **AKS Node Size & Count (`aks/`)**: Increase `node_vmsize` to at least `Standard_D4ds_v5` and scale the `agent_count` up to 3 or more for high availability. 
- **Additional Node Pools (`aks/`)**: Use the `node_pools` variable map to create dedicated VM pools if your workloads require specific isolation or powerful spot instances.
- **Database Sizing (`database/`)**: Increase the `dbsku` to a compute-optimized General Purpose tier (e.g., `GP_Standard_D4ds_v4`) rather than basic Burstable models (`B_Standard_B1ms`), and increase `dbsize` as needed.

- **AKS OS Disk Type & VM Cache (`aks/`)**: 
    - **Testing/Low-Cost**: If using small VM sizes (like `Standard_B2ms`), set `os_disk_type = "Managed"`. These VM tiers often lack the sufficient cache required for Ephemeral disks.
    - **Production**: For high performance and faster node scaling, it is recommended to use `os_disk_type = "Ephemeral"`. This requires selecting a VM size with a cache large enough to accommodate your `os_disk_size_gb` (e.g., `Standard_D4ds_v5` or larger).

### 4. CI/CD Testing (GitHub Actions)
This repository includes starter workflows in `.github/` to automatically test your Terraform code directly against your Azure environment using **GitHub Actions**. 

To use these workflows:
1. Fork or clone this repository to your own GitHub account.
2. Configure your Azure credentials as GitHub Repository Secrets (e.g., `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID`).
3. During pull requests to `develop` or merges to `main`, the pipeline validates the Terraform plans for the `hub` and the various `aks` environments (`lab`, `dev`, `preprod`, `prod`). 

*(Note: The embedded `.gitlab-ci.yml` files are used internally by the author for maintenance and can be ignored by standard GitHub users).*

---

## 🛡️ License
Distributed under the MIT License. See `LICENSE` for more information.

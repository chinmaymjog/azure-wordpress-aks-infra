# Problem

## What are you building, and why?

Terraform for a Hub-Spoke Azure platform - AKS, Container Registry, Key
Vault, and a managed MySQL database - built to host the WordPress app in
the companion `azure-wordpress-aks` repo, but generic enough for any
containerized workload.

## Goals

- Provision a working AKS cluster + database + registry with a single
  command sequence (`deploy.sh hub apply` → `db apply` → `aks apply`).
- Keep node SSH access, image pulls, and cluster access all
  identity-based - no static credentials living on disk or in git.
- Get someone from clone to a running cluster without needing a CI/CD
  pipeline or multiple environments configured first.

## Non-Goals

- Multi-environment support on this branch - see the `advanced` branch
  for dev/lab/preprod/prod.
- Automated CI/CD deploys on this branch - see `advanced` for the
  OIDC-based GitHub Actions pipeline.

## Success Criteria

- `./deploy.sh hub apply && ./deploy.sh db apply && ./deploy.sh aks apply`
  produces a working cluster with no manual Azure Portal steps.
- `terraform validate` passes on a fresh clone with zero local setup
  beyond `.env` and Terraform/Azure CLI.

## Risks

- Real Azure cost from the moment `hub`/`aks`/`db` are applied - all
  billed resources, no free tier. Run `./deploy.sh aks destroy` /
  `db destroy` / `hub destroy` when done experimenting.
- `authorized_ip_range` in `aks-main-weu-terraform.tfvars` needs updating
  to your own IP before it's meaningful as an access restriction.

## Notes

- Requires an Azure subscription, Terraform, the Azure CLI, and a Service
  Principal with `Contributor` + `User Access Administrator`.
- See the main [README.md](../README.md) for the full setup walkthrough.

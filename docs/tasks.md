# Tasks

Keep this short and current. Delete finished work you don't need a
record of - this is a working list, not an audit log.

## Now

- [ ] ...

## Next

- [ ] `database/` still takes `db_subnet_id`/`key_vault_id`/
      `mysql_dns_zone_id` as plain vars sourced from a committed
      `global_hub.tfvars` with real resolved Azure IDs, instead of
      pulling them from Hub remote state like `aks/main.tf` does.

## Done

- [x] Consolidated from 5 separate repos into `azure-wordpress-aks-infra`
      + `azure-wordpress-aks`, fixing real bugs found in review (disabled
      TLS enforcement on MySQL, public network access on ACR/Key Vault,
      an unbounded provider version, missing Terraform outputs, a
      plaintext-admin-kubeconfig dump, a local-file SSH key dependency
      that broke CI) (2026-09-15)
- [x] Simplified `main` to a single environment with no CI/CD
      requirement - `advanced` branch keeps the full dev/lab/preprod/prod
      + OIDC CI/CD setup (2026-09-15)
- [x] Rotated the Azure Storage account key and Docker Hub password found
      in the old (pre-consolidation) `charts` repo history (2026-09-15)
- [x] Added VNet peering between the Hub and AKS VNets and a private
      endpoint for ACR - closes a real connectivity gap (AKS previously
      had no network path to MySQL or ACR, only working DNS) (2026-09-15)

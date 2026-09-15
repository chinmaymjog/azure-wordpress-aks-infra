# Tasks

Keep this short and current. Delete finished work you don't need a
record of - this is a working list, not an audit log.

## Now

- [ ] ...

## Next

- [ ] Rotate the Azure Storage account key and Docker Hub password that
      were found in the old (pre-consolidation) `charts` repo history -
      confirmed not present in this repo, but were real credentials.
- [ ] Consider a private endpoint for ACR once the AKS subnet ID is
      known, to fully close the network-level access gap noted in
      docs/architecture.md.

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

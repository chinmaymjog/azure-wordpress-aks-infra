# azure-wordpress-aks-infra

Terraform for a Hub-Spoke Azure platform (AKS, ACR, Key Vault, MySQL Flexible Server). Components: `hub/`, `aks/`, `database/`, shared code in `modules/`. `deploy.sh` wraps plan/apply for a human operator.

## Hard rules
- **Never** run `terraform plan`, `apply` or `destroy`, or `deploy.sh`, and never ask for Azure credentials. You have none; infrastructure changes are applied by the owner after review.
- Never commit state, `*.tfstate*`, secrets, keys, tokens, or real IPs/IDs that are not already in the repo.
- Don't change `.github/workflows/`, `deploy.sh`, backend/state configuration, or `global.auto.tfvars` unless the issue asks for it.
- The azurerm provider is pinned to `~> 4.0`; the v5 migration is tracked separately (issue #23). Do not bump provider majors.

## Working on issues
- Verify with `terraform fmt -check -recursive`, and for each component `cd <hub|aks|database> && terraform init -backend=false && terraform validate` (same as CI in `.github/workflows/verify.yml`).
- Call out in the PR any change that could force replacement of existing resources (renames, `for_each` key changes, changed immutable arguments) so the owner can check the real `terraform plan`.
- Keep changes minimal and scoped to the issue; one issue per PR.
- Open a PR against `advanced` that references the issue (`Fixes #N`). Never push to `advanced` directly.
- Update `docs/` (architecture, tasks) when design or scope changes.

# Contributing

- Open an issue before large changes.
- Run `terraform fmt -recursive` and `terraform validate` for each changed component (`hub`, `aks`, `database`); CI runs the same.
- Describe any change that may force resource replacement, and attach a redacted `terraform plan` summary where relevant.
- One logical change per pull request, referencing the issue (`Fixes #N`).
- Never commit state files, secrets or real tenant/subscription identifiers.

## AI-assisted contributions
AI tools are welcome, with these rules:
- **You are accountable** for every line you submit. Read and understand the code; unreviewed AI output will be closed.
- **Disclose** substantial AI assistance in the PR description.
- Never paste credentials, state files or tenant data into AI tools, issues or PRs.
- Low-effort, bulk or off-topic AI-generated PRs and issues may be closed without review.

## Maintainer automation
The Claude agent workflow is restricted to the repository owner and has no Azure credentials. Agent-authored PRs get the same review and CI requirements as any other PR and are never auto-merged.

## Security issues
See [SECURITY.md](SECURITY.md); do not file them as public issues.

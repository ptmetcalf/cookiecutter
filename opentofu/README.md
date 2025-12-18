# OpenTofu Cookiecutter Template

Cookiecutter template for OpenTofu/Terraform IaC repositories.

## Usage

Generate a new OpenTofu IaC repository from this template:

```bash
cookiecutter https://github.com/YOUR_ORG/cookiecutter --directory opentofu
```

You'll be prompted for:
- `repo_name` - Name of your new IaC repository
- `stack_name` - Name of your OpenTofu stack (e.g., "app", "infrastructure")
- `github_actions_repo` - Reference to your github-actions repo (e.g., "YOUR_ORG/github-actions")
- `github_actions_ref` - Version tag to pin to (e.g., "v1.0.0")
- `tofu_version` - OpenTofu version to use (or "latest")

## Generated Repository Structure

```
my-iac-repo/
├── .github/
│   └── workflows/
│       └── iac.yml           # OpenTofu workflow (plan on PR, apply on dispatch)
├── infra/
│   └── stacks/
│       └── app/              # Your OpenTofu stack
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│           └── versions.tf
├── env/
│   ├── dev.tfvars
│   └── prod.tfvars
├── Makefile                   # Local development helpers
└── iac.yaml                   # Metadata for automation
```

## Workflow Behavior

After generation:

- **Pull Requests**: Automatically run `tofu plan` for dev environment and comment the plan on the PR
- **Deployments**: Use `workflow_dispatch` to manually trigger apply for dev or prod
- **Protection**: Configure GitHub Environment protection rules for prod (required reviewers, deployment branches)

## Local Development

The generated repo includes a Makefile for local development:

```bash
# Format tofu code
make fmt

# Plan changes (default: dev)
make plan ENV=dev

# Apply changes (dev only, prod must use CI)
make apply ENV=dev
```

## Next Steps

After generating a repo:

1. **Configure Backend**: Add OpenTofu backend configuration (S3, Azure Storage, etc.) to `versions.tf`
2. **Add Cloud Auth**: The reusable workflows have placeholders for OIDC authentication - configure for your cloud provider
3. **Create GitHub Environments**: Set up "dev" and "prod" environments in GitHub with appropriate protection rules
4. **Add Secrets**: Store necessary credentials and backend configs as GitHub secrets or environment secrets
5. **Develop Your Stack**: Add resources, modules, and variables to your OpenTofu code

## Upgrading Workflows

To upgrade to a newer version of the reusable workflows:

1. Update `github_actions_ref` in the generated repo's workflow file
2. Change from `@v1.0.0` to `@v1.1.0` (or desired version)
3. Test in dev before applying to prod

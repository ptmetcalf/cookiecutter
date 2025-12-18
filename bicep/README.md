# Bicep Cookiecutter Template

Cookiecutter template for Azure Bicep IaC repositories.

## Usage

Generate a new Bicep IaC repository from this template:

```bash
cookiecutter https://github.com/YOUR_ORG/cookiecutter --directory bicep
```

You'll be prompted for:
- `repo_name` - Name of your new Bicep repository
- `stack_name` - Name of your application/stack (e.g., "app", "infrastructure")
- `github_actions_repo` - Reference to your github-actions repo (e.g., "YOUR_ORG/github-actions")
- `github_actions_ref` - Version tag to pin to (e.g., "v1.0.0")
- `bicep_version` - Bicep version to use (or "latest")
- `azure_resource_group_dev` - Azure resource group for dev environment
- `azure_resource_group_prod` - Azure resource group for prod environment
- `azure_location` - Azure region (e.g., "eastus", "westeurope")

## Generated Repository Structure

```
my-bicep-repo/
├── .github/
│   └── workflows/
│       └── iac.yml           # Bicep workflow (what-if on PR, deploy on dispatch)
├── infra/
│   └── bicep/
│       └── main.bicep        # Main Bicep template
├── env/
│   ├── dev.bicepparam        # Dev environment parameters
│   └── prod.bicepparam       # Prod environment parameters
├── Makefile                   # Local development helpers
└── iac.yaml                   # Metadata for automation
```

## Workflow Behavior

After generation:

- **Pull Requests**: Automatically run `what-if` analysis for dev environment and comment results on the PR
- **Deployments**: Use `workflow_dispatch` to manually trigger deploy for dev or prod
- **Safety Check**: Pre-deployment what-if runs before actual deployment
- **Protection**: Configure GitHub Environment protection rules for prod (required reviewers, deployment branches)

## Local Development

The generated repo includes a Makefile for local development:

```bash
# Build Bicep template
make build

# Lint Bicep code
make lint

# Run what-if analysis (default: dev)
make whatif ENV=dev

# Deploy (dev only, prod must use CI)
make deploy ENV=dev
```

## Next Steps

After generating a repo:

1. **Create Resource Groups**: Pre-create Azure resource groups for dev and prod environments
   ```bash
   az group create --name rg-myapp-dev --location eastus
   az group create --name rg-myapp-prod --location eastus
   ```

2. **Configure Azure OIDC**: Set up federated credentials in Azure AD
   - Create an App Registration in Azure AD
   - Add federated credentials for your GitHub repository
   - Grant appropriate RBAC permissions (Contributor on resource groups)

3. **Add GitHub Secrets**: Store the following as GitHub secrets:
   - `AZURE_CLIENT_ID` - App Registration client ID
   - `AZURE_TENANT_ID` - Azure AD tenant ID
   - `AZURE_SUBSCRIPTION_ID` - Azure subscription ID

4. **Create GitHub Environments**: Set up "dev" and "prod" environments with protection rules
   - Enable required reviewers for prod
   - Restrict deployments to specific branches

5. **Develop Your Templates**: Add Azure resources to your Bicep templates

## Upgrading Workflows

To upgrade to a newer version of the reusable workflows:

1. Update `github_actions_ref` in the generated repo's workflow file
2. Change from `@v1.0.0` to `@v1.1.0` (or desired version)
3. Test in dev before applying to prod

## Deployment Scopes

By default, the template uses `resourceGroup` scope. You can modify the workflow to use other scopes:

- **subscription** - Deploy at subscription level
- **managementGroup** - Deploy at management group level
- **tenant** - Deploy at tenant level

Update the `deployment_scope` parameter in `.github/workflows/iac.yml` and adjust parameters accordingly.

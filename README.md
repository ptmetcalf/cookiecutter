# Cookiecutter Templates for IaC

Collection of Cookiecutter templates for Infrastructure as Code repositories.

## Available Templates

### 1. OpenTofu Template

For OpenTofu/Terraform-based infrastructure.

**Generate:**
```bash
cookiecutter https://github.com/YOUR_ORG/cookiecutter --directory opentofu
```

**Features:**
- OpenTofu plan on pull requests with PR comments
- Apply via workflow_dispatch for dev/prod
- Pre-configured Makefile for local development
- Reusable workflow integration

[Full Documentation](./opentofu/README.md)

### 2. Bicep Template

For Azure Bicep-based infrastructure.

**Generate:**
```bash
cookiecutter https://github.com/YOUR_ORG/cookiecutter --directory bicep
```

**Features:**
- What-if analysis on pull requests with PR comments
- Deploy via workflow_dispatch for dev/prod
- Pre-configured Makefile for local Azure CLI commands
- Support for resource group, subscription, and management group scopes

[Full Documentation](./bicep/README.md)

## Prerequisites

All templates require:

1. **Cookiecutter** installed:
   ```bash
   pip install cookiecutter
   ```

2. **GitHub Actions Workflows** repository set up (see [github-actions repo](../github-actions))

3. **GitHub Environments** configured for dev and prod with appropriate protection rules

## Template Structure

Each template lives in its own directory:

```
cookiecutter/
├── opentofu/           # OpenTofu/Terraform template
│   ├── cookiecutter.json
│   ├── README.md
│   └── {{cookiecutter.repo_name}}/
├── bicep/              # Azure Bicep template
│   ├── cookiecutter.json
│   ├── README.md
│   └── {{cookiecutter.repo_name}}/
└── README.md           # This file
```

## Usage Pattern

All templates follow the same pattern:

1. **Generate** a new repo from the template
2. **Configure** cloud authentication (OIDC recommended)
3. **Set up** GitHub Environments with protection rules
4. **Add** necessary secrets
5. **Develop** your infrastructure code

## Workflow Behavior

All generated repositories include:

- **PR Workflow**: Automatic plan/what-if analysis with PR comments
- **Deploy Workflow**: Manual deployment via workflow_dispatch
- **Environment Protection**: Prod deployments require approval
- **Local Development**: Makefile for running operations locally

## Upgrading

To upgrade generated repos to newer workflow versions:

1. Update `github_actions_ref` in the workflow file
2. Change from `@v1.0.0` to `@v1.1.0`
3. Test in dev before deploying to prod

## Adding New Templates

To add a new template type:

1. Create a new directory (e.g., `pulumi/`, `cdk/`)
2. Add `cookiecutter.json` with template variables
3. Create `{{cookiecutter.repo_name}}/` directory structure
4. Add template-specific README
5. Update this README with the new template

## Support

For issues or questions:
- OpenTofu/Bicep reusable workflows: See [github-actions repo](../github-actions)
- Template generation issues: Create an issue in this repo

terraform {
  required_version = ">= 1.6.0"

  # Azure Storage Backend (Default)
  # Partial configuration - details provided via backend.hcl file
  # See: backend.azure.hcl.example for configuration template
  # Initialize with: tofu init -backend-config=backend.hcl
  backend "azurerm" {}

  # Alternative Backends (comment out azurerm above and uncomment one of these):

  # AWS S3 Backend
  # backend "s3" {}

  # GCP Cloud Storage Backend
  # backend "gcs" {}

  # Terraform Cloud
  # backend "remote" {}

  required_providers {
    # Add your required providers here

    # Azure Resource Manager
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 3.0"
    # }

    # Azure Active Directory / Entra ID
    # azuread = {
    #   source  = "hashicorp/azuread"
    #   version = "~> 2.0"
    # }

    # Azure Databricks
    # databricks = {
    #   source  = "databricks/databricks"
    #   version = "~> 1.0"
    # }

    # GitHub
    # github = {
    #   source  = "integrations/github"
    #   version = "~> 6.0"
    # }

    # AWS
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 5.0"
    # }

    # Google Cloud
    # google = {
    #   source  = "hashicorp/google"
    #   version = "~> 5.0"
    # }
  }
}

# Provider configurations
# Uncomment and configure based on your needs

# Azure Resource Manager Provider
# Uses Azure CLI authentication from GitHub Actions azure/login
# provider "azurerm" {
#   features {}
#   # Optional: Specify different subscription
#   # subscription_id = "00000000-0000-0000-0000-000000000000"
# }

# Azure Active Directory / Entra ID Provider
# Uses Azure CLI authentication from GitHub Actions azure/login
# provider "azuread" {
#   # Optional: Specify different tenant
#   # tenant_id = "00000000-0000-0000-0000-000000000000"
# }

# Azure Databricks Provider
# Uses Azure CLI authentication from GitHub Actions azure/login
# provider "databricks" {
#   host = azurerm_databricks_workspace.main.workspace_url
#
#   # Azure authentication (recommended for Azure Databricks)
#   azure_workspace_resource_id = azurerm_databricks_workspace.main.id
#
#   # Alternative: Token-based authentication (for non-Azure Databricks)
#   # token = var.databricks_token
# }

# GitHub Provider
# Requires GITHUB_TOKEN environment variable or PAT
# provider "github" {
#   owner = "your-org"
#   # token = var.github_token  # Or use GITHUB_TOKEN env var
# }

# AWS Provider
# provider "aws" {
#   region = "us-east-1"
# }

# Google Cloud Provider
# provider "google" {
#   project = "my-project"
#   region  = "us-central1"
# }

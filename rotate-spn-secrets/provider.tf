terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.31.0"
    }
    github = {
      source = "integrations/github"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  use_oidc        = true
  features {}
}

provider "github" {
  token = data.azurerm_key_vault_secret.github-token.value
  owner = var.github_organization
}

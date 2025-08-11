# AD groups
data "azuread_group" "cdx_developers" {
  display_name     = "cdx-developers"
  security_enabled = true
}

# SPN
data "azuread_application" "cdx_dns_admin_sp" {
  display_name = "cdx-dns-admin-sp"
}

data "azuread_application" "cdx_prod_admin_sp" {
  display_name = "cdx-prod-admin-sp"
}

# KV
data "azurerm_resource_group" "rg" {
  name = "management-rg"
}
data "azurerm_key_vault" "kv" {
  name                = "sas-cdx-management-kv"
  resource_group_name = data.azurerm_resource_group.rg.name
}
data "azurerm_key_vault_secret" "github-token" {
  name         = "CDX-SPN-ROTATE-PAT"
  key_vault_id = data.azurerm_key_vault.kv.id
}
data "azurerm_key_vault_secret" "gh_packages" {
  name         = "gh-packages"
  key_vault_id = data.azurerm_key_vault.kv.id
}
# GitHub Repos
data "github_repository" "cdx_terraform_infra" {
  full_name = "github_org/cdx-terraform-infra"
}

data "github_repository" "devex_yopass_infra" {
  full_name = "github_org/devex-yopass-infra"
}

data "github_repository" "devex_tailscale" {
  full_name = "github_org/devex-tailscale"
}

data "github_repository" "cdx-tools-observability" {
  full_name = "github_org/cdx-tools-observability"
}

data "github_repository" "cdx_frontdoor_cdn_rules" {
  full_name = "github_org/cdx-frontdoor-cdn-rules"
}

data "github_repository" "cdx_flux" {
  full_name = "github_org/cdx-flux"
}

data "github_repository" "cdx_terraform_infra_sdc" {
  full_name = "github_org/cdx-terraform-infra-sdc"
}

data "github_repository" "platform_tools_infra" {
  full_name = "github_org/platform-tools-infra"
}



terraform {
  backend "azurerm" {
    storage_account_name = "sascdxprodtfstatesa"
    container_name       = "tfbackend"
    key                  = "infra/cdx-management/rotate-spn-secrets/terraform.state"
    subscription_id      = "<Subscription id>"
    tenant_id            = "<Tenant id>"
    resource_group_name  = "management-rg"
    use_azuread_auth     = true
  }
}

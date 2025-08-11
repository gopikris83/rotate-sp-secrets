locals {
  current_time    = timestamp()
  set_expiry_date = timeadd(local.current_time, "4320h")
}

output "expiry_date" {
  value = local.set_expiry_date
}

resource "time_rotating" "password_rotate" {
  rotation_days = 30
}

resource "azuread_application_password" "cdx_dns_admin_sp_pwd" {
  application_id    = data.azuread_application.cdx_dns_admin_sp.id
  display_name      = data.azuread_application.cdx_dns_admin_sp.display_name
  end_date_relative = "4320h"
  rotate_when_changed = {
    rotation = time_rotating.password_rotate.id
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "azuread_application_password" "cdx_prod_admin_sp_pwd" {
  application_id    = data.azuread_application.cdx_prod_admin_sp.id
  display_name      = data.azuread_application.cdx_prod_admin_sp.display_name
  end_date_relative = "4320h"
  rotate_when_changed = {
    rotation = time_rotating.password_rotate.id
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "azuread_application_password" "cdx_prod_subscriptions_sp_pwd" {
  application_id    = data.azuread_application.cdx_prod_subscriptions_sp.id
  display_name      = data.azuread_application.cdx_prod_subscriptions_sp.display_name
  end_date_relative = "4320h"
  rotate_when_changed = {
    rotation = time_rotating.password_rotate.id
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "azuread_application_password" "cdx_adgroup_admin_sp_pwd" {
  application_id    = data.azuread_application.cdx_adgroup_admin_sp.id
  display_name      = data.azuread_application.cdx_adgroup_admin_sp.display_name
  end_date_relative = "4320h"
  rotate_when_changed = {
    rotation = time_rotating.password_rotate.id
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "azuread_application_password" "d360_aks_pipelines" {
  application_id    = azuread_application.d360_aks_pipelines.id
  display_name      = azuread_application.d360_aks_pipelines.display_name
  end_date_relative = "4320h"
  rotate_when_changed = {
    rotation = time_rotating.password_rotate.id
  }
  lifecycle {
    create_before_destroy = true
  }
}

## CDX SPN Key Vault Secrets update
resource "azurerm_key_vault_secret" "cdx_dns_admin_sp_password" {
  name            = "cdx-dns-admin-sp-client-secret"
  value           = azuread_application_password.cdx_dns_admin_sp_pwd.value
  key_vault_id    = data.azurerm_key_vault.kv.id
  expiration_date = local.set_expiry_date
  content_type    = "service principal password"
  lifecycle {
    ignore_changes = [
      expiration_date,
    ]
  }
}

resource "azurerm_key_vault_secret" "cdx_prod_admin_sp_password" {
  name            = "cdx-prod-admin-sp-client-secret"
  value           = azuread_application_password.cdx_prod_admin_sp_pwd.value
  key_vault_id    = data.azurerm_key_vault.kv.id
  expiration_date = local.set_expiry_date
  content_type    = "service principal password"
  lifecycle {
    ignore_changes = [
      expiration_date,
    ]
  }
}

resource "azurerm_key_vault_secret" "cdx_prod_subscriptions_sp_password" {
  name            = "cdx-prod-subscriptions-sp-client-secret"
  value           = azuread_application_password.cdx_prod_subscriptions_sp_pwd.value
  key_vault_id    = data.azurerm_key_vault.kv.id
  expiration_date = local.set_expiry_date
  content_type    = "service principal password"
  lifecycle {
    ignore_changes = [
      expiration_date,
    ]
  }
}

resource "azurerm_key_vault_secret" "cdx_adgroup_admin_sp_password" {
  name            = "cdx-adgroup-admin-sp-client-secret"
  value           = azuread_application_password.cdx_adgroup_admin_sp_pwd.value
  key_vault_id    = data.azurerm_key_vault.kv.id
  expiration_date = local.set_expiry_date
  content_type    = "service principal password"
  lifecycle {
    ignore_changes = [
      expiration_date,
    ]
  }
}

# Github Org Secrets Update
resource "github_actions_organization_secret" "githuborg_cdx_admin_client_secret" {
  secret_name     = "CDX_ADMIN_CLIENT_SECRET"
  visibility      = "selected"
  plaintext_value = azuread_application_password.cdx_prod_admin_sp_pwd.value
  selected_repository_ids = [
    data.github_repository.cdx_terraform_infra.repo_id,
    data.github_repository.devex_yopass_infra.repo_id,
    data.github_repository.devex_tailscale.repo_id,
    data.github_repository.cdx-tools-observability.repo_id,
    data.github_repository.cdx_frontdoor_cdn_rules.repo_id,
    data.github_repository.cdx_flux.repo_id,
    data.github_repository.cdx_terraform_infra_sdc.repo_id,
    data.github_repository.platform_tools_infra.repo_id,
  ]
  lifecycle {
    replace_triggered_by = [
      azuread_application_password.cdx_prod_admin_sp_pwd.value
    ]
  }
}

resource "github_actions_organization_secret" "githuborg_cdx_admin_client_id" {
  secret_name     = "CDX_ADMIN_CLIENT_ID"
  visibility      = "selected"
  plaintext_value = data.azuread_application.cdx_prod_admin_sp.client_id
  selected_repository_ids = [
    data.github_repository.cdx_firewall_rules.repo_id,
    data.github_repository.cdx_terraform_adgroup_creator.repo_id,
    data.github_repository.devex_terraform_github.repo_id,
    data.github_repository.cdx_terraform_subscription_kickstart.repo_id,
    data.github_repository.cdx_terraform_infra.repo_id,
    data.github_repository.devex_yopass_infra.repo_id,
    data.github_repository.devex_backstage.repo_id,
    data.github_repository.cdx_app_registrations.repo_id,
    data.github_repository.cdx_cdxprobe.repo_id,
    data.github_repository.devex_tailscale.repo_id,
    data.github_repository.cdx-tools-observability.repo_id,
    data.github_repository.cdx_frontdoor_cdn_rules.repo_id,
    data.github_repository.devex_github_self_hosted_runner.repo_id,
    data.github_repository.devex_internal_tools.repo_id,
    data.github_repository.cdx_waf_rules.repo_id,
    data.github_repository.azure_dns_terraform.repo_id,
    data.github_repository.devex_uptime_private_location.repo_id,
    data.github_repository.cdx_flux.repo_id,
    data.github_repository.cdx_azure_messaging_services.repo_id,
    data.github_repository.cdx_terraform_infra_sdc.repo_id,
    data.github_repository.avd_terraform_infra.repo_id,
    data.github_repository.azure_defender_config.repo_id,
    data.github_repository.platform_tools_infra.repo_id,
    data.github_repository.azure_apim_services.repo_id,
    data.github_repository.automation_workflows.repo_id,
    data.github_repository.azure_policy_exemptions.repo_id,
  ]
}


resource "github_actions_organization_secret" "githuborg_cdx_subscription_client_secret" {
  secret_name     = "CDX_SUBSCRIPTIONS_CLIENT_SECRET"
  visibility      = "selected"
  plaintext_value = azuread_application_password.cdx_prod_subscriptions_sp_pwd.value
  selected_repository_ids = [
    data.github_repository.cdx_terraform_subscription_kickstart.repo_id,
    data.github_repository.cdx_terraform_infra.repo_id
  ]
  lifecycle {
    replace_triggered_by = [
      azuread_application_password.cdx_prod_subscriptions_sp_pwd.value
    ]
  }
}

resource "github_actions_organization_secret" "githuborg_cdx_dns_client_secret" {
  secret_name     = "CDX_DNS_CLIENT_SECRET"
  visibility      = "selected"
  plaintext_value = azuread_application_password.cdx_dns_admin_sp_pwd.value
  selected_repository_ids = [
    data.github_repository.cdx_terraform_subscription_kickstart.repo_id,
    data.github_repository.cdx_terraform_infra.repo_id
  ]
  lifecycle {
    replace_triggered_by = [
      azuread_application_password.cdx_dns_admin_sp_pwd.value
    ]
  }
}

resource "github_actions_organization_secret" "githuborg_adgroup_admin_client_secret" {
  secret_name     = "CDX_ADGROUP_ADMIN_SECRET"
  visibility      = "selected"
  plaintext_value = azuread_application_password.cdx_adgroup_admin_sp_pwd.value
  selected_repository_ids = [
    data.github_repository.cdx_terraform_adgroup_creator.repo_id
  ]
  lifecycle {
    replace_triggered_by = [
      azuread_application_password.cdx_adgroup_admin_sp_pwd.value
    ]
  }
}

resource "github_actions_organization_secret" "d360_aks_pipelines_client_secret" {
  secret_name     = "D360_AKS_PIPELINES_CLIENT_SECRET"
  visibility      = "selected"
  plaintext_value = azuread_application_password.d360_aks_pipelines.value
  selected_repository_ids = [
    data.github_repository.book_api_searchpanel.repo_id
  ]
  lifecycle {
    replace_triggered_by = [
      azuread_application_password.d360_aks_pipelines.value
    ]
  }
}

resource "github_actions_organization_secret" "d360_aks_pipelines_client_id" {
  secret_name     = "D360_AKS_PIPELINES_CLIENT_ID"
  visibility      = "selected"
  plaintext_value = azuread_application.d360_aks_pipelines.client_id
  selected_repository_ids = [
    data.github_repository.book_api_searchpanel.repo_id
  ]
}


resource "github_actions_organization_secret" "gh_packages" {
  secret_name     = "GH_PACKAGES"
  visibility      = "selected"
  plaintext_value = data.azurerm_key_vault_secret.gh_packages.value
  selected_repository_ids = [
    data.github_repository.cdx_terraform_infra.repo_id
  ]
}

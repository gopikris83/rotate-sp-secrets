# D360_aks_pipelines
resource "azuread_application" "d360_aks_pipelines" {
  display_name = "d360-aks-pipelines-sp"
  owners       = data.azuread_group.cdx_developers.members
}

resource "azuread_service_principal" "d360_aks_pipelines" {
  client_id                    = azuread_application.d360_aks_pipelines.client_id
  app_role_assignment_required = false
  owners                       = data.azuread_group.cdx_developers.members
}

# Service Principal Secret Rotation

## 📋 Overview

This directory handles rotating service principal secrets and updating them to the Key Vault along with GitHub organization-level secrets. The rotation is automated using OpenID Connect (OIDC) for secure, passwordless authentication. This project is only used for platform team azure service principal secret rotation. I have another project for rotating teams/service-specific service principals

## 🔐 What Secrets Are Being Rotated

Platform team uses service principals for various platform automation and managing Azure infrastructure provisioning through GitHub workflows with Terraform projects.

### Service Principals

1. **prod-admin-sp** - Platform administration and automation
2. **dns-admin-sp** - DNS management and updates
3. **prod-subscription-sp** - Subscription-level operations
4. **adgroup-admin-sp** - Azure AD group management

## 🔄 How SPN Secret Rotation Works

### OIDC Authentication

* Secret rotation is handled using **OIDC (OpenID Connect)** to authenticate Azure within the workflow
* No stored credentials required - uses federated identity
* More secure than traditional service principal secrets

**For more information:** [Configuring OpenID Connect in Azure](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure)

### Rotation Architecture

* Service Principal **prod-admin-sp** rotates its own secrets and other SPN secrets
* This is handled through **Federated Credentials** configured in the SPN

**More info on:** [Federated credentials](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#create-an-azure-active-directory-application-and-service-principal)

![Federated credentials](images/Federated%20Credentials.png)

### Key Components

1. **Federated Identity**
   - SPN **prod-admin-sp** has federated identity configured with GitHub Organization
   - Acts as user identity to perform secret rotation
   - No password/secret stored in GitHub

2. **API Permissions**
   - **prod-admin-sp** requires this API permission:
     - `Application.ReadWrite.All`
   - This permission allows rotating secrets of other service principals

3. **Key Vault Access**
   - SPN **prod-admin-sp** has rbac in Key Vaults:
   - Allows updating rotated secrets in Key Vault

4. **GitHub Secrets Management**
   - Terraform manages organization secrets for rotation
   - Rotated secrets automatically updated in GitHub
   - All workflows use updated credentials automatically

5. **Automated Schedule**
   - Workflow runs as scheduled job
   - **Rotation Period**: Every 5th day of the month
   - Can also be triggered manually if needed

## 📁 Project Structure

```
rotate-spn-secrets/
├── backend.tf          # Remote state configuration
├── data.tf             # Data sources for existing resources
├── main.tf             # Main Terraform configuration
├── provider.tf         # Azure provider setup
├── service_principals.tf  # SPN secret rotation logic
├── variables.tf        # Input variables
├── images/             # Documentation images
└── README.md           # This file
```

## 🚀 Deployment

### Prerequisites

- Service Principal with federated credentials configured
- API permissions (Application.ReadWrite.All)
- Key Vault access policies configured
- GitHub organization admin access
- Terraform >= 1.12

### CI/CD Deployment

Rotation is automated via GitHub Actions:
- **Schedule**: Runs on the 5th of every month
- **Manual Trigger**: Can be triggered on-demand
- **OIDC Authentication**: Uses federated credentials
- **Notifications**: Alerts on success/failure

## 🛠️ Troubleshooting

### Common Issues

#### OIDC Authentication Failure

**Problem**: Federated credential authentication fails

**Solutions**:
- Verify federated credential configuration in Entra ID
- Check GitHub OIDC trust relationship
- Ensure correct subject claim in federated credential
- Review GitHub Actions token permissions

#### Key Vault Access Denied

**Problem**: Unable to update secrets in Key Vault

**Solutions**:
- Verify access policies/ RBAC for prod-admin-sp
- Check Key Vault firewall rules
- Ensure SPN has required permissions (Get, List, Set)/ RBAC roles

#### GitHub Secrets Not Updating

**Problem**: Rotated secrets not reflected in GitHub

**Solutions**:
- Verify GitHub PAT token permissions
- Check organization secret update permissions
- Review Terraform GitHub provider configuration
- Ensure correct organization scope

## 📖 Related Documentation

- [Azure Federated Credentials](https://docs.microsoft.com/en-us/azure/active-directory/develop/workload-identity-federation)
- [GitHub OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [Azure Key Vault Secrets](https://docs.microsoft.com/en-us/azure/key-vault/secrets/)
- [Service Principal Management](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal)

## 🔙 Back to Main Documentation

[← Back to CDX Terraform Infrastructure](../README.md)

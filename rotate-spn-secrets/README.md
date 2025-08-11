# Rotate CDX Service Principals secrets using OIDC

This directory handles rotating the service principal secrets and updating the same to the Key vault along with GitHub Organization level secrets.

### What azure resource secrets are being rotated

CDX Platform uses three service principals for various platform automation and managing the Azure infrastructure provisioning through GitHub workflow with terraform projects.

The service principals are:
1. cdx-prod-admin-sp
2. cdx-dns-admin-sp
3. cdx-prod-subscription-sp
4. cdx-adgroup-admin-sp
<br>
<br>

### How does the SPN secret rotation work

* Secret rotation is being handled using OIDC (OpenID Connect) to authenticate Azure within the workflow.
For more information on OIDC - [Configuring OpenID Connect in Azure](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure)

<br>

* Service Principal <span style="color:orange">*cdx-prod-admin-sp*</span> will be used for rotating its own secrets and other SPN <span style="color:yellow">*cdx-prod-subscription-sp, cdx-dns-admin-sp*</span> secrets. This is handled through Federated Credentials configured in SPN. More info on [Federated credentials](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#create-an-azure-active-directory-application-and-service-principal) <br>
  ![Federated credentials](images/Federated%20Credentials.png)
  <br>
* SPN <span style="color:orange">*cdx-prod-admin-sp*</span> will have a federated identity configured with GitHub Organization which acts as a user identity to perform the secret rotation and update the secrets to the key vault and GitHub secrets
* cdx-prod-admin-sp needs these API permissions (Application.Read.All, Application.ReadWrite.All) to rotate the secrets of other service principals.
* For updating the rotated secrets in key vaults secrets <span style="color:orange">*cdx-prod-admin-sp*</span> SPN is given the following access policies [Get, List, Recover] in Key Vaults
* Secret rotation through terraform is managed in this directory (rotate-spn-secrets) and it has been decided to manage only the organization secrets for rotation.
* The Workflow runs as scheduled job and the rotation period is set on every 5th day of the month.

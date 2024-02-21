data "azuread_service_principal" "aks" {
  # The ID of the managed "Azure Kubernetes Service AAD Server" application
  # https://learn.microsoft.com/en-us/azure/aks/kubelogin-authentication#how-to-use-kubelogin-with-aks
  client_id = "6dae42f8-4368-4678-94ff-3960e28e3630"
}

 
data "azuread_client_config" "current" {}

 
# RG and AKS cluster

resource "azurerm_resource_group" "main" {
  location = var.location
  name     = var.resource_group_name
  
}

module "azure_aks" {
  source  = "Azure/aks/azurerm"
  version = "~> 7"

  prefix                    = var.cluster_name
  resource_group_name       = azurerm_resource_group.main.name
  automatic_channel_upgrade = "stable"
  local_account_disabled    = false

  # # Configure as "Azure AD authentication with Azure RBAC"
  # # https://learn.microsoft.com/en-us/azure/aks/manage-azure-rbac
  rbac_aad_managed                  = false
  rbac_aad                          = false
  role_based_access_control_enabled = false
  rbac_aad_azure_rbac_enabled       = false
  

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_contributor_role_assigned_subnet_ids = {
    resource_group = azurerm_resource_group.main.id
  }

  depends_on = [azurerm_resource_group.main]

  agents_size             = var.vm_size
  node_os_channel_upgrade = "NodeImage"

  network_plugin = "azure"
  network_policy = "azure"

  
}
 
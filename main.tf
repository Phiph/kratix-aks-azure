
terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.11"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.87"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
  required_version = ">= 1.3.0"
  backend "azurerm" {
    
  }
}

provider "azapi" {
  subscription_id = var.subscription_id
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

provider "azuread" {
}

module "base" {
  source = "./modules/base"

  subscription_id = var.subscription_id
  location        = var.location
  vm_size         = var.vm_size
  cluster_name    = var.cluster_name
}



module "kratix" {
  source       = "./modules/kratix"
  location     = var.location
  git_url      = var.git_url
  git_username = base64encode(var.git_username)
  git_password = base64encode(var.git_password)
  cluster_name = module.base.cluster-name
  depends_on   = [module.base]
}


module "worker" {
  source = "./modules/base"

  subscription_id     = var.subscription_id
  location            = var.location
  vm_size             = var.vm_size
  resource_group_name = "ref-arch-worker"
  providers = {
    helm       = helm.worker
    kubernetes = kubernetes.worker
  }
  cluster_name = "worker"
}


module "kratix-worker" {
  source              = "./modules/kratix"
  location            = var.location
  git_url             = var.git_url
  git_username        = base64encode(var.git_username)
  git_password        = base64encode(var.git_password)
  cluster_name        = module.haven.cluster-name
  resource_group_name = "ref-arch-worker"
  worker_cluster      = true
  providers = {
    helm       = helm.worker
    kubernetes = kubernetes.worker
  }
  depends_on = [module.worker]
}



provider "kubernetes" {
  host                   = module.base.aks_host
  client_certificate     = base64decode(module.base.aks_cluster_admin_certificate)
  client_key             = base64decode(module.base.aks_admin_key)
  cluster_ca_certificate = base64decode(module.base.aks_cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.base.aks_host
    client_certificate     = base64decode(module.base.aks_cluster_admin_certificate)
    client_key             = base64decode(module.base.aks_admin_key)
    cluster_ca_certificate = base64decode(module.base.aks_cluster_ca_certificate)
  }
}


provider "kubernetes" {
  alias                  = "worker"
  host                   = module.worker.aks_host
  client_certificate     = base64decode(module.worker.aks_cluster_admin_certificate)
  client_key             = base64decode(module.worker.aks_admin_key)
  cluster_ca_certificate = base64decode(module.worker.aks_cluster_ca_certificate)
}

provider "helm" {
  alias = "worker"
  kubernetes {
    host                   = module.worker.aks_host
    client_certificate     = base64decode(module.worker.aks_cluster_admin_certificate)
    client_key             = base64decode(module.worker.aks_admin_key)
    cluster_ca_certificate = base64decode(module.worker.aks_cluster_ca_certificate)
  }
}
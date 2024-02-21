
variable "subscription_id" {
  description = "Azure Subscription (ID) to use"
  type        = string
}

variable "location" {
  description = "Azure region to deploy into"
  type        = string
}

variable "vm_size" {
  description = "The Azure VM instances type to use as \"Agents\" (aka Kubernetes Nodes) in AKS"
  type        = string
  default     = "Standard_D2_v2"
}

variable "cluster_name" {
  description = "Name for the AKS cluster"
  type        = string
  default     = "ref-arch"
}

variable "git_url" {
  description = "The URL of the git repository"
  type        = string
}

variable "git_username" {
  description = "The username of the git user"
  type        = string
}

variable "git_password" {
  description = "The pass of the git user"
  sensitive   = true
}
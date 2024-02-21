variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "ref-arch"
}

variable "location" {
  description = "Azure region to deploy into"
  type        = string
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

variable "cluster_name" {
  description = "Name for the AKS cluster"
  type        = string
  default     = "ref-arch"
}

variable "worker_cluster" {
  description = "Is this a worker cluster?"
  type        = bool
  default     = false
}
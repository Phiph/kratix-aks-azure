

## Deploy Platform Cluster
resource "helm_release" "example" {
  count      = var.worker_cluster ? 0 : 1
  name       = "kratix"
  repository = "https://syntasso.github.io/helm-charts"
  chart      = "kratix"
  version    = "0.52.0"

  values = [
    templatefile("${path.module}/templates/platform-values.yaml", { git_url = var.git_url, git_username = var.git_username, git_password = var.git_password })
  ]
  depends_on = [helm_release.cert_manager]
}




resource "helm_release" "worker" {
  count      = var.worker_cluster ? 1 : 0
  name       = "kratix"
  repository = "https://syntasso.github.io/helm-charts"
  chart      = "kratix-destination"
  version    = "0.0.1"

  values = [
    templatefile("${path.module}/templates/worker-values.yaml", { git_url = var.git_url, git_username = var.git_username, git_password = var.git_password })
  ]
  depends_on = [helm_release.cert_manager]
}



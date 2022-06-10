resource "kubernetes_secret" "remote_cluster" {
  metadata {
    name      = var.name
    namespace = "argocd"
    labels    = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name   = var.name
    server = var.server_url
    config = jsonencode({
      tlsClientConfig = {
        insecure = false
        caData   = var.ca_data
        certData = var.cert_data
        keyData  = var.key_data
      }
    })
  }
}

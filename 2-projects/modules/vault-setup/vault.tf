resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

data "kubernetes_service_account_v1" "vault_sa" {
  metadata {
    name = "vault"
    namespace = "vault"
  }
}

data "kubernetes_secret" "vault_jwt" {
  metadata {
    name      = "${data.kubernetes_service_account_v1.vault_sa.default_secret_name}"
    namespace = "vault"
  }
}

resource "vault_kubernetes_auth_backend_config" "config" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = "https://kubernetes.default"
  #kubernetes_ca_cert     = var.cluster_cert
  #token_reviewer_jwt     = data.kubernetes_secret.vault_jwt.data["token"]
  #issuer                 = "api"
  disable_iss_validation = "true"
}

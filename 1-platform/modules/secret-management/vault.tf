resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "random_password" "vault_token" {
  length           = 16
  special          = false
}

# Dev deployment. Do not use this seriously.
# All data wiped on restart.
resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.20.1"

  timeout = 600
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.vault.id

  values = [<<EOF
server:
  dev:
    enabled: true
    devRootToken: "${random_password.vault_token.result}"
ui:
  enabled: true
EOF
  ]
}


resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.5.3"

  timeout = 600
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.vault.id

  depends_on = [helm_release.vault]
}


# Wait for CRDs to be created
resource "time_sleep" "wait_30_seconds" {
  depends_on = [helm_release.external_secrets]

  create_duration = "60s"
}


resource "kubernetes_secret" "vault_token" {
  metadata {
    name = "vault-token"
    namespace = kubernetes_namespace.vault.id
  }

  data = {
    token = random_password.vault_token.result
  }
}

# This has to apply after the CRDs are processed
resource "kubectl_manifest" "test" {
    yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-backend
  namespace: ${kubernetes_namespace.vault.id}
spec:
  provider:
    vault:
      server: "http://vault.${kubernetes_namespace.vault.id}:8200"
      path: "secret"
      version: "v2"
      auth:
        # points to a secret that contains a vault token
        # https://www.vaultproject.io/docs/auth/token
        tokenSecretRef:
          name: "vault-token"
          key: "token"
YAML

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

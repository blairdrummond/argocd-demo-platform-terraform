locals {
  service_account = "vault-external-secrets"
  role_name       = "external-secrets-${var.namespace}"
  path            = "kv_${var.namespace}"
  policy_name     = "external-secrets-${var.namespace}"
}

resource "vault_mount" "secret_store" {
  path        = local.path
  type        = "kv-v2"
  description = "Secrets for namespace ${var.namespace}"
}

resource "vault_policy" "external_secrets" {
  name = local.policy_name

  policy = <<EOT
path "${local.path}/*" {
  capabilities = ["create","read","update","delete","list"]
}
EOT
}

resource "kubernetes_service_account_v1" "external_secrets" {
  metadata {
    name      = local.service_account
    namespace = var.namespace
  }
}

resource "vault_kubernetes_auth_backend_role" "example" {
  backend                          = var.vault_backend
  role_name                        = local.role_name
  bound_service_account_names      = [local.service_account]
  bound_service_account_namespaces = [var.namespace]
  token_ttl                        = 3600
  token_policies                   = [local.policy_name]
  #audience                         = "vault"

  depends_on = [
    vault_policy.external_secrets
  ]
}



# This has to apply after the CRDs are processed
resource "kubernetes_manifest" "secret_store" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind = "SecretStore"
    metadata = {
      name = "vault-backend"
      namespace = var.namespace
    }
    spec = {
      provider = {
        vault = {
          server = "http://vault.vault:8200"
          path = local.path
          version = "v2"
          auth = {
            kubernetes = {
              mountPath = var.vault_backend
              role = local.role_name
              serviceAccountRef = {
                name = local.service_account
              }
            }
          }
        }
      }
    }
  }
}


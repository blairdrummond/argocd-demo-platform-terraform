# We need these to 
resource "kubernetes_namespace" "ns" {
  for_each = toset(var.platform_namespaces)

  metadata {
    name = each.key
  }
}


resource "kubernetes_manifest" "applicationset" {
    manifest = {
      apiVersion = "argoproj.io/v1alpha1"
      kind = "ApplicationSet"
      metadata = {
        name = "platform"
        namespace = "argocd"
        annotations = {
          "argocd.argoproj.io/sync-wave" = "2"
        }
      }
      spec = {
        generators = [
          {
            git = {
              repoURL = var.repo
              revision = var.revision
              directories = [
                {
                  path = var.path
                }
              ]
            }
          }
        ]
        template = {
          metadata = {
            name = "platform-${var.cluster_name}-{{path[0]}}"
            namespace = "argocd"
          }
          spec = {
            project = "platform"
            source = {
              repoURL = var.repo
              targetRevision = var.revision
              path = "{{path}}"
            }
            destination = {
              server = var.cluster_url
            }
          }
        }
      }
    }
}

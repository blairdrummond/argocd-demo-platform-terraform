locals {
    # WARNING: This is a very important restriction.
    # This repo can deploy *anything* so you need it locked down.
    repo = "https://github.com/blairdrummond/argocd-demo-platform-manifests"
}

resource "kubernetes_manifest" "appproject" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind = "AppProject"
    metadata = {
      name = "platform"
      namespace = "argocd"
      annotations = {
        "argocd.argoproj.io/sync-wave" = "1"
      }
    }
    spec = {
      # This is a very privileged role
      clusterResourceWhitelist = [
        {
          group = "*"
          kind = "*"
        }
      ]
      destinations = [
        {
          namespace = "*"
          server = "*"
        }
      ]
      # WARNING: This is a very important restriction.
      # This repo can deploy *anything* so you need it locked down.
      sourceRepos = [
        local.repo
      ]
      roles = [
        {
          # A role which provides read-only access to all applications in the project
          name = "read-only"
          description = "Read-only privileges to my-project"
          policies = [
            "p, proj:platform:read-only, applications, get, platform/*, allow"  
          ]
          groups = ["platform"]
        }
      ]
    }
  }
}

# # Namespaces
# resource "kubernetes_namespace" "dev_platform" {
#     providers = {
#       kubernetes = kubernetes.k8s_dev
#     }
# }
# 
# resource "kubernetes_namespace" "prod_platform" {
#     providers = {
#       kubernetes = kubernetes.k8s_prod
#     }
# }

# # The ApplicationSet for the platform repo
# module "platform" {
# 
#     for_each = {
#       "dev" = {
#           revision    = "main"
#           cluster_url = local.dev_url
#           autosync    = true
#       }
# 
#       "prod" = {
#           revision    = "prod"
#           cluster_url = local.prod_url
#           autosync    = false
#       }
#     }
# 
#     source = "./modules/platform-project/"
# 
#     repo         = local.repo
#     revision     = each.value.revision
#     cluster_name = each.key
#     cluster_url  = each.value.cluster_url
#     autosync     = each.value.autosync
# 
# }


# resource "kubernetes_manifest" "applicationset" {
#     manifest = {
#       apiVersion = "argoproj.io/v1alpha1"
#       kind = "ApplicationSet"
#       metadata = {
#         name = "platform"
#         namespace = "argocd"
#         annotations = {
#           "argocd.argoproj.io/sync-wave" = "2"
#         }
#       }
#       spec = {
#         generators = [
#           {
#             git = {
#               repoURL = "https://github.com/argoproj/applicationset.git"
#               revision = "HEAD"
#               directories = [
#                 {
#                   path = "examples/git-generator-directory/cluster-addons/*"
#                 }
#               ]
#             }
#           }
#         ]
#         template = {
#           metadata = {
#             name = "platform-{{app}}"
#             namespace = "argocd"
#           }
#           spec = {
#             project = "platform"
#             source = {
#               repoURL = "https://github.com/blairdrummond/terragrunt-experiment-manifests.git"
#               targetRevision = "HEAD"
#               path = "applications/platform/{{app}}"
#             }
#             destination = {
#               server = "https://kubernetes.default.svc"
#               namespace = "{{app}}"
#             }
#             syncPolicy = {
#               automated = {
#                 prune = "true"
#                 selfHeal = "true"
#               }
#             }
#           }
#         }
#       }
#     }
# }


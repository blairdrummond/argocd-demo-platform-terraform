resource "kubernetes_manifest" "appproject" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind = "AppProject"
    metadata = {
      name = var.namespace
      namespace = "argocd"
      annotations = {
        "argocd.argoproj.io/sync-wave" = "1"
      }
    }
    spec = {
      # NO CRDs ALLOWED.
      clusterResourceBlacklist = var.crds_allowed ? [] : [
        {
          group = "*"
          kind = "*"
        }
      ]
      clusterResourceWhitelist = var.crds_allowed ? [
        {
          group = "*"
          kind = "*"
        }
      ] : []
      # Can only deploy to the managed clusters, not the ArgoCD cluster
      destinations = [
        for cluster_name, cluster in var.clusters :
        {
          namespace = var.namespace
          server = cluster.value.cluster_url
        }
      ]
      sourceRepos = [var.repo]
      roles = [
        {
          # A role which provides read-only access to all applications in the project
          name = "read-only"
          description = "Read-only privileges to my-project"
          policies = [
            "p, proj:platform:read-only, applications, get, platform/*, allow"          ]
          groups = ["platform"]
        }
      ]
    }
  }
}


resource "kubernetes_manifest" "application" {
    for_each = var.clusters

    manifest = {
      apiVersion = "argoproj.io/v1alpha1"
      kind = "Application"
      metadata = {
        name = "project-${each.key}-${var.namespace}"
        namespace = "argocd"
        annotations = {
          "argocd.argoproj.io/sync-wave" = "2"
        }
      }
      spec = {
        project = var.namespace
        source = {
          repoURL = var.repo
          targetRevision = each.value.revision
          path = "."
        }
        destination = {
          name = each.value.cluster server = each.value.cluster_url
          namespace = var.namespace
        }
        syncPolicy = each.value.autosync ? {
          automated = {
            prune = "true"
            selfHeal = "true"
          }
        } : {}
      }
    }
}


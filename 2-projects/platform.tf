locals {
    # WARNING: This is a very important restriction.
    # This repo can deploy *anything* so you need it locked down.
    repo = "https://github.com/blairdrummond/argocd-demo-platform-manifests"
}

# Creates some of the namespaces, configures basic stuff
module "dev_platform" {
  source = "./modules/platform-project/"

  platform_namespaces = var.platform_namespaces

  providers = {
    kubernetes = kubernetes.k8s_dev
  }
}

module "prod_platform" {
  source = "./modules/platform-project/"

  platform_namespaces = var.platform_namespaces

  providers = {
    kubernetes = kubernetes.k8s_prod
  }
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
        local.repo,
        "https://charts.jetstack.io",
        "https://open-policy-agent.github.io/gatekeeper/charts",
        "https://kubernetes.github.io/ingress-nginx"
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

resource "kubernetes_manifest" "platform_application" {
    manifest = {
      apiVersion = "argoproj.io/v1alpha1"
      kind = "Application"
      metadata = {
        name = "platform"
        namespace = "argocd"
        annotations = {
          "argocd.argoproj.io/sync-wave" = "2"
        }
      }
      spec = {
        project = "platform"
        source = {
          repoURL = var.platform_manifests_repo
          targetRevision = var.platform_manifests_repo_revision
          path = "."
        }
        # Deploying back into the shared-services cluster
        destination = {
          server    = "https://kubernetes.default.svc"
          namespace = "argocd"
        }

        syncPolicy = {
          automated = {
            prune      = true
            allowEmpty = true
          }
        }
      }
    }
}

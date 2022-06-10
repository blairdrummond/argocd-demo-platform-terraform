resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "3.26.8"

  timeout = 600
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.argocd.id

  values = [<<EOF
server:
  config:
    kustomize.buildOptions: "--load-restrictor LoadRestrictionsNone --enable-helm"
EOF
  ]
}

resource "helm_release" "argocd_applicationset" {
  name       = "argocd-applicationset"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-applicationset"
  version    = "1.6.0"

  timeout = 600
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.argocd.id

  depends_on = [helm_release.argocd]
}



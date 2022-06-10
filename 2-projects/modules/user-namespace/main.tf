resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
    labels = {
      "ingress/enabled" = var.ingress_enabled    
      "contact"         = var.contact_email
      "billing_id"      = var.billing_id
    }
  }
}

resource "kubernetes_resource_quota_v1" "no_loadbalancers_nodeports" {
  metadata {
    name = "restrict-nodeports-loadbalancers"
    namespace = kubernetes_namespace.ns.id
  }
  spec {
    hard = {
      "services.loadbalancers" = 0
      "services.nodeports" = 0
    }
  }
}

# We need these to 
resource "kubernetes_namespace" "ns" {
  for_each = toset(var.platform_namespaces)

  metadata {
    name = each.key
    labels = {
        "ingress/enabled" = "true"
    }
  }
}
  
# Namespace 
resource "kubernetes_network_policy_v1" "egress_to_enabled_ns" {
  count = contains(var.platform_namespaces, "ingress-system") ? 1 : 0

  metadata {
    name = "egress-to-ingress-enabled-ns"
    namespace = "ingress-system"
  }

  spec {
    pod_selector {}

    egress {
      to {
        namespace_selector {
          match_labels = {
            "ingress/enabled" = "true"
          }
        }
      }
    }

    policy_types = ["Egress"]
  }

  depends_on = [kubernetes_namespace.ns["ingress-system"]]
}


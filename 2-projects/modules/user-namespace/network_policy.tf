resource "kubernetes_network_policy_v1" "allow_same_ns" {
  count = var.network_policy_allow_same_ns ? 1 : 0

  metadata {
    name      = "allow-same-ns"
    namespace = kubernetes_namespace.ns.id
  }

  spec {
    # All pods in the namespace
    pod_selector {}

    # Ingress in the ns
    ingress {
      from {
        pod_selector {}
      }
    }

    # Egress in the ns
    egress {
      to {
        pod_selector {}
      }
    }

    policy_types = ["Ingress", "Egress"]
  }
}


resource "kubernetes_network_policy_v1" "allow_dns" {
  count = var.network_policy_allow_same_ns ? 1 : 0

  metadata {
    name      = "allow-dns"
    namespace = kubernetes_namespace.ns.id
  }

  spec {
    # All pods in the namespace
    pod_selector {}

    # Egress in the ns
    egress {
      ports {
        port     = "53"
        protocol = "UDP"
      }

      ports {
        port     = "53"
        protocol = "TCP"
      }
    }

    policy_types = ["Egress"]
  }
}


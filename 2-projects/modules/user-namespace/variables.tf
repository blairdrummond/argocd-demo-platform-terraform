variable "namespace" {
  description = "The cluster URL"
}

variable "ingress_enabled" {
  description = "Are Ingress objects allowed here?"
  type        = bool
}

variable "contact_email" {
  description = "Contact email of the team responsible for this app"
}

# This can be used, for example, with Kubecost
# https://guide.kubecost.com/hc/en-us/articles/4407601807383-Kubernetes-Cost-Allocation#kubernetes-cost-allocation
variable "billing_id" {
  description = "Code for billing metadata (optional)"
  default     = ""
}

variable "vault_backend" {
  description = "Vault kubernetes auth backend"
}

variable "network_security_enabled" {
  description = "Create Network policy to restrict traffic to/from the namespace"
  type        = bool
  default     = false
}

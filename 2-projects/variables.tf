variable "vault_dev_url" {}
variable "vault_dev_token" {}

variable "vault_prod_url" {}
variable "vault_prod_token" {}

variable "platform_manifest_repo" {
    description = "Platform manifests repo"
}

variable "platform_namespaces" {
    description = "Platform namespaces to create"
    type        = list
}

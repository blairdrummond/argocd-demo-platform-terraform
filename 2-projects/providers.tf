# k8s
provider "kubernetes" {
  config_path    = "../0-infrastructure/clusters/cluster-dev/config.yaml"
  alias          = "k8s_dev"
}

provider "kubernetes" {
  config_path    = "../0-infrastructure/clusters/cluster-prod/config.yaml"
  alias          = "k8s_prod"
}

# Helm
provider "helm" {
  kubernetes {
    config_path    = "../0-infrastructure/clusters/cluster-dev/config.yaml"
  }
  alias = "helm_dev"
}

provider "helm" {
  kubernetes {
    config_path    = "../0-infrastructure/clusters/cluster-prod/config.yaml"
  }
  alias = "helm_prod"
}

# # kubectl
# provider "kubectl" {
#   config_path    = "../0-infrastructure/clusters/cluster-dev/config.yaml"
#   alias          = "kubectl_dev"
# }
# 
# provider "kubectl" {
#   config_path    = "../0-infrastructure/clusters/cluster-prod/config.yaml"
#   alias          = "kubectl_prod"
# }

provider "vault" {
    address = var.vault_dev_url
    token   = var.vault_dev_token

    alias   = "vault_dev"
}


provider "vault" {
    address = var.vault_prod_url
    token   = var.vault_prod_token

    alias   = "vault_prod"
}

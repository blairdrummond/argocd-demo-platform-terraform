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

# kubectl
provider "kubectl" {
  config_path    = "../0-infrastructure/clusters/cluster-dev/config.yaml"
  alias          = "kubectl_dev"
}

provider "kubectl" {
  config_path    = "../0-infrastructure/clusters/cluster-prod/config.yaml"
  alias          = "kubectl_prod"
}

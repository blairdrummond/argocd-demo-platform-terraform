terraform {
  required_providers {
    kubernetes = {
      source   = "hashicorp/kubernetes"
      version  = "2.11.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.2.0"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "./clusters/cluster-shared/config.yaml"
}

provider "helm" {
  kubernetes {
    config_path    = "./clusters/cluster-shared/config.yaml"
  }
}

provider "kubectl" {
  config_path    = "./clusters/cluster-shared/config.yaml"
}


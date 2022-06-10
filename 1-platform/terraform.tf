terraform {
  required_providers {
    kubernetes = {
      source   = "hashicorp/kubernetes"
      version  = "2.11.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
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


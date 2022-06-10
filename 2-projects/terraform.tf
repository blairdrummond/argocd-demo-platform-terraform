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

    vault = {
      source = "hashicorp/vault"
      version = "3.6.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "../0-infrastructure/clusters/cluster-shared/config.yaml"
}

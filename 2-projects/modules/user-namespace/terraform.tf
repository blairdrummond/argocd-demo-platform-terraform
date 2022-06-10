terraform {
  required_providers {
    kubernetes = {
      source   = "hashicorp/kubernetes"
      version  = "2.11.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.6.0"
    }
  }
}

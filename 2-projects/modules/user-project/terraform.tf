terraform {
  required_providers {
    kubernetes = {
      source   = "hashicorp/kubernetes"
      version  = "2.11.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

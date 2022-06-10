module "decepticons_ns_dev" {

  source = "./modules/user-namespace/"

  namespace     = "decepticons"
  vault_backend = "kubernetes"
    
  providers = {
        kubernetes = kubernetes.k8s_dev
        vault      = vault.vault_dev
    }
}


module "decepticons_ns_prod" {

  source = "./modules/user-namespace/"

  namespace     = "decepticons"
  vault_backend = "kubernetes"
    
  providers = {
        kubernetes = kubernetes.k8s_prod
        vault      = vault.vault_prod
    }
}


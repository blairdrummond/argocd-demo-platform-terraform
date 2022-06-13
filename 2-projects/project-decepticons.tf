module "decepticons_ns_dev" {

  source = "./modules/user-namespace/"

  namespace       = "decepticons"
  ingress_enabled = true
  vault_backend   = "kubernetes"
    
  providers = {
        kubernetes = kubernetes.k8s_dev
        vault      = vault.vault_dev
    }
}


module "decepticons_ns_prod" {

  source = "./modules/user-namespace/"

  namespace       = "decepticons"
  ingress_enabled = false
  vault_backend   = "kubernetes"
    
  providers = {
        kubernetes = kubernetes.k8s_prod
        vault      = vault.vault_prod
    }
}


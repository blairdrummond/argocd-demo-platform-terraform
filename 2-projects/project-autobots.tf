module "autobots_ns_dev" {

  source = "./modules/user-namespace/"

  namespace       = "autobots"
  ingress_enabled = true 

  vault_backend = "kubernetes"
    
  providers = {
        kubernetes = kubernetes.k8s_dev
        vault      = vault.vault_dev
    }
}


module "autobots_ns_prod" {

  source = "./modules/user-namespace/"

  namespace       = "autobots"
  ingress_enabled = true 

  vault_backend = "kubernetes"
    
  providers = {
        kubernetes = kubernetes.k8s_prod
        vault      = vault.vault_prod
    }
}




module "dev_vault_setup" {
    source = "./modules/vault-setup/"

    providers = {
        kubernetes = kubernetes.k8s_dev
        vault      = vault.vault_dev
    }
}


module "prod_vault_setup" {
    source = "./modules/vault-setup/"

    providers = {
        kubernetes = kubernetes.k8s_prod
        vault      = vault.vault_prod
    }
}

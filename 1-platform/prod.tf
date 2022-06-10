# # Set up Fluxcd
# module "prod_fluxcd" {
#     source = "./modules/fluxcd/"
# 
#     providers = {
#         kubectl    = kubectl.kubectl_prod
#     }
# }

module "prod_secrets" {
    source = "./modules/secret-management/"

    providers = {
        kubernetes = kubernetes.k8s_prod
        helm       = helm.helm_prod
        kubectl    = kubectl.kubectl_prod
    }
}

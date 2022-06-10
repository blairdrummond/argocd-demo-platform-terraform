# # Set up Fluxcd
# module "dev_fluxcd" {
#     source = "./modules/fluxcd/"
# 
#     providers = {
#         kubectl    = kubectl.kubectl_dev
#     }
# }

module "dev_secrets" {
    source = "./modules/secret-management/"

    providers = {
        kubernetes = kubernetes.k8s_dev
        helm       = helm.helm_dev
        kubectl    = kubectl.kubectl_dev
    }
}

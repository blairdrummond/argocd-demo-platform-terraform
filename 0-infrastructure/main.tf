# Set up ArgoCD
module "shared_services" {
    source = "./modules/shared-cluster-platform"
}

module "cluster_secret" {
    for_each = {
        prod = local.prod_cluster
        dev  = local.dev_cluster
    }

    source = "./modules/cluster-secret/"

    name       = each.value.clusters[0].name
    server_url = each.value.clusters[0].cluster.server
    ca_data    = each.value.clusters[0].cluster["certificate-authority-data"]
    cert_data  = each.value.users[0].user["client-certificate-data"]
    key_data   = each.value.users[0].user["client-key-data"]
}

# data "local_sensitive_file" "prod_cluster" {
#     filename = "../0-infrastructure/clusters/cluster-prod/config.yaml"
# }
# 
# data "local_sensitive_file" "dev_cluster" {
#     filename = "../0-infrastructure/clusters/cluster-dev/config.yaml"
# }
# 
# locals {
#     prod_cluster = yamldecode(data.local_sensitive_file.prod_cluster.content)
#     dev_cluster  = yamldecode(data.local_sensitive_file.dev_cluster.content)
# 
#     prod_url = local.prod_cluster.clusters[0].cluster.server
#     dev_url  = local.dev_cluster.clusters[0].cluster.server
# }

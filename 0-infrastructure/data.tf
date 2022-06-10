data "local_sensitive_file" "prod_cluster" {
    filename = "clusters/cluster-prod/config.yaml"
}

data "local_sensitive_file" "dev_cluster" {
    filename = "clusters/cluster-dev/config.yaml"
}

locals {
    prod_cluster = yamldecode(data.local_sensitive_file.prod_cluster.content)
    dev_cluster  = yamldecode(data.local_sensitive_file.dev_cluster.content)
}


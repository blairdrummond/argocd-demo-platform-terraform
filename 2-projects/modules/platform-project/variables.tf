variable "repo" {
    description = "The repo to deploy from"
}

variable "revision" {
    description = "Revision of the git repo"
}

variable "path" {
    description = "The path to deploy within the repo"
    default     = "*"
}

 variable "cluster_name" {
    description = "The Cluster name. E.g. 'dev'"
 }

 variable "cluster_url" {
    description = "The Cluster to deploy to"
 }

variable "platform_namespaces" {
    description = "Platform namespaces to create"
    type = list
}

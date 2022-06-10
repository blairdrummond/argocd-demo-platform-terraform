variable "namespace" {
    description = "The namespace to create"
}

variable "repo" {
    description = "The repo to deploy from"
}

variable "github_topics" {
    description = "Topics to tag the github repo with"
    default = []
}


variable "github_template_repo_owner" {
    description = "The Template repo owner, e.g. 'liatrio'"
}
variable "github_template_repo" {
    description = "The Template repo to instantiate"
}

variable "clusters" {
    description = "The Cluster to deploy to"

    # Example
    # clusters = {
    #   dev = {
    #     cluster_url  = ""
    #     revision     = ""
    #     autosync     = <true|false>
    #     # for branch protection
    #     require_approval = <true|false>
    #   }
    # }
}

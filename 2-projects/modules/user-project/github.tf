locals {
    repo_name = "argocd-${var.namespace}-manifests"
}

resource "github_repository" "project_repo" {
  name        = local.repo_name
  description = "ArgoCD Manifests for the ${var.namespace} project"

  topics = concat(["argocd-manifests"], var.github_topics)

  visibility = "public"

  template {
    owner      = "github"
    repository = var.github_template_repo
  }
}

resource "github_branch" "deploy_branch" {
  for_each = var.clusters

  repository = local.repo_name
  branch     = each.value.revision

  depends_on = [github_repository.project_repo]
}

resource "github_branch_protection" "protect_deploys" {
  for_each = var.clusters

  repository_id = github_repository.project_repo.node_id

  pattern          = each.value.revision
  enforce_admins   = each.value.require_approval
  allows_deletions = true

  depends_on = [github_branch.project_repo[each.key]]
}

# ArgoCD Multi-Cluster demo

> **Note**
> We are just hacking this together in stages using terraform and Makefiles.
> Terragrunt would make this more elagant.

> **Warning**
> The AppProject RBAC illustrates the concept, but is not comprehensive.
> For example, user namespaces cannot deploy cluster resources, but they can
> deploy any namespaced resource, including Ingresses and Network Policies.
> Depending on the situation, this may or may not be appropriate.

Design:

    - There are three clusters: `shared-services`, `dev`, & `prod`
    - `shared-services` has an ArgoCD installation, which manages the `dev` and `prod` clusters.
    - The `dev` and `prod` clusters are bootstrapped (using ArgoCD) to have
      + Hashicorp Vault
      + External Secrets (using [this setup](https://external-secrets.io/v0.5.3/guides-multi-tenancy/#managed-secretstore-per-namespace))
    - Once the `dev` and `prod` clusters have been prepped, there is `projects/` terraform module/repo which:
      + Creates a github repo for a project team, initialized with a template
      + We provide the team with a namespace, and an ArgoCD App pointing to their repo to deploy their resources.
      + The terraform also provides them a place to do some secret management and deploy managed services.

The above design is implemented using three "stages":

- 0-infrastructure
- 1-platform
- 2-projects

## How users use the project repo they get

The repo uses a flat structure:

```
.
|- app1/
|- app2/
\- app3/
```

Each app gets turned into an ArgoCD Application using the [ApplicationSet GitGenerator](https://argocd-applicationset.readthedocs.io/en/stable/Generators-Git/).
Users can put Kustomize deployments, Raw Helm Charts, or Helm Chart **references** via FluxCD CRs.

### ~~Wait what? FluxCD?~~

Recall that everything in the user's git repo gets deployed to the `dev` and/or `prod` cluster, but while ArgoCD *is* installed on the shared-services cluster, it is not installed on the `dev` or `prod` clusters. Therefore, if you want a declarative way to deploy Helm Charts from the user repo, you need Flux, ArgoCD, or a similar tool in the `dev` and `prod` clusters.

FluxCD doesn't have the same nice management/rbac features as ArgoCD, but it is better at handling Helm. So instead of installing ArgoCD in the destination clusters, we chose FluxCD. You will see that it has very elagant Helm management, especially when combined with Vault+External-Secrets and Kustomize.

> Nevermind, it was a pain to set up.

# Future Work

- Scope out the necessary Gatekeeper Policies
  + Might want to restrict prod to only deploy from `prod` branches on the `sourceRepos`, for example? (or protected branches, anyway)

- Gatekeeper Policy for image control!!!

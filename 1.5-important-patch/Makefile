# The Default AppProject that comes with ArgoCD can deploy anything, from anywhere.
# That's bad. You want to at least restrict the source repos that it can be deploying from.

REPO := https://github.com/blairdrummond/argocd-demo-platform-manifests.yaml

dry-run patch:
	@printf '%s' $$(tput setaf 2)
	@echo "# You *Need* to modify the permissions of the default ArgoCD AppProject."
	@echo "# By default it can deploy everything, everywhere, from any place."
	@echo "# (therefore, there's a risk of users deploying arbitrary things)"
	@printf '%s' $$(tput sgr0)

	@echo "# ($@) Default AppProject for ArgoCD"
	@if test $@ = "dry-run"; then \
		CMD="kubectl --dry-run=client -o yaml" ; \
	else \
		CMD="kubectl"; \
	fi; \
	KUBECONFIG=../0-infrastructure/clusters/cluster-shared/config.yaml \
		$$CMD patch appproject \
			-n argocd default \
			--type='json' \
			-p='[{"op": "replace", "path": "/spec/sourceRepos", "value":["$(REPO)"]}]'



KUBECTL := kubectl --context k3d-cluster-shared

clusters: cluster-dev cluster-prod cluster-shared
cluster-dev cluster-prod cluster-shared:
	mkdir -p clusters/$@/
	k3d cluster create $@
	k3d kubeconfig get $@ > clusters/$@/config.yaml

apply:
	terraform init
	terraform apply

setup-cluster-secrets: 
	find clusters -name '*.yaml' | while read line; do \
		export NAME=$$(yq e .clusters[0].name $$line); \
		export CA_DATA=$$(yq e .clusters[0].cluster.certificate-authority-data $$line); \
		export SERVER="https://$$(kubectl get endpoints --context $$(yq e .clusters[0].name $$line) -o json | jq -r '.. | .ip? // empty'):6443"; \
		export CERT=$$(yq e .users[0].user.client-certificate-data $$line); \
		export KEY=$$(yq e .users[0].user.client-key-data $$line); \
		cat example-cluster-secret.yaml \
			| envsubst \
			| yq -P e - \
			| $(KUBECTL) create -n argocd -f - ; \
	done

join-docker-networks:
	find clusters -name '*.yaml' | while read line; do \
		export NAME=$$(yq e .clusters[0].name $$line); \
		test $$NAME = k3d-cluster-shared && continue; \
		docker network connect $$NAME k3d-cluster-shared-server-0; \
	done

argocd-login:
	TOKEN=$$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d); \
		  echo "$$(tput setaf 2)ArgoCD Username: admin$$(tput sgr0)"; \
		  echo "$$(tput setaf 2)ArgoCD Password: $$TOKEN$$(tput sgr0)"
	kubectl port-forward -n argocd svc/argocd-server 8000:80


vault-put-key:
	VAULT_ADDR=http://0.0.0.0:8200 \
	VAULT_TOKEN=$$(kubectl get secret -n vault vault-token -o jsonpath='{.data.token}' | base64 -d) \
		vault kv put secret/creds password=$$(echo $$RANDOM | md5sum | head -c 20)

vault-login:
	@TOKEN=$$(kubectl get secret -n vault vault-token -o jsonpath='{.data.token}' | base64 -d); \
		  echo "$$(tput setaf 2)Vault Token: $$TOKEN$$(tput sgr0)"
	kubectl port-forward -n vault svc/vault-ui 8200:8200

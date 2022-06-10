KUBECTL_DEV := kubectl --kubeconfig ../0-infrastructure/clusters/cluster-dev/config.yaml 
KUBECTL_PROD := kubectl --kubeconfig ../0-infrastructure/clusters/cluster-prod/config.yaml 


vault-dev:
	$(KUBECTL_DEV) port-forward -n vault svc/vault 8201:8200	

vault-prod:
	$(KUBECTL_PROD) port-forward -n vault svc/vault 8202:8200


plan apply init:
	@echo "You need to port-forward the Vault instances first, if you have not done so."
	@echo "In a proper setup, you would have ingresses for vault, so this wouldn't be necessary."
	TF_VAR_vault_dev_url=http://0.0.0.0:8201 \
	TF_VAR_vault_prod_url=http://0.0.0.0:8202 \
	TF_VAR_vault_dev_token=$$($(KUBECTL_DEV) get secret -n vault vault-token -o jsonpath='{.data.token}' | base64 -d) \
	TF_VAR_vault_prod_token=$$($(KUBECTL_PROD) get secret -n vault vault-token -o jsonpath='{.data.token}' | base64 -d) \
		terraform $@

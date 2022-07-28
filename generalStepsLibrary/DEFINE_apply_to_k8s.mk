## $(call apply_to_k8s, some.yaml,$(IMAGE),$(DEPLOYMENT_NAME),$(DEPLOYMENT_URI))
define apply_to_k8s
	IMAGE=$2 \
	DEPLOYMENT_NAME=$3 \
	SUBNETS_JSON=$4 \
	DEPLOYMENT_URI=$5 \
	$(ENVSUBST_EXEC) < $1 | $(KUBECTL_EXEC) apply $(KUBECTL_OPTIONS) --context=$(DEPLOY_KUBER_CONTEXT) -f -
endef

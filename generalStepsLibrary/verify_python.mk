verify: env## verify application
	$(DOCKER_EXEC) run $(DOCKER_OPTIONS) --rm -v $(PWD):/app $(DOCKER_BASE) /bin/sh -c "cd /app; . ./infra/scripts/verify.sh"
	$(DOCKER_EXEC) run $(DOCKER_OPTIONS) --rm -v $(PWD)/infra:/infra $(KUBECONFORM_IMAGE)


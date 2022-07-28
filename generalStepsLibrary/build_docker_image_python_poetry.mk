build: env ## build application
	$(SUDO) $(DOCKER_EXEC) build $(DOCKER_OPTIONS) --build-arg python_base_image=$(DOCKER_BASE) . -f infra/Dockerfile -t $(IMAGE_TAG)

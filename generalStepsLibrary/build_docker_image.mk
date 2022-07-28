build: env ## build application
	$(SUDO) $(DOCKER_EXEC) build $(DOCKER_OPTIONS) . -f infra/Dockerfile -t $(IMAGE_TAG)

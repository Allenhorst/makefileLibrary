push: env ## push docker image
	$(SUDO) $(DOCKER_EXEC) push $(DOCKER_OPTIONS) $(IMAGE_TAG);

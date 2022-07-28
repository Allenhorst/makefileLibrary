env:
	$(eval APP_VERSION=$(shell $(POETRY_EXEC) version -s))
	$(eval IMAGE_VERSION=$(APP_VERSION)$(IMAGE_SUFFIX))
	$(eval APP_NAME=$(shell $(POETRY_EXEC) version | cut -d " " -f1))
	$(eval IMAGE_TAG=$(DOCKER_REGISTRY)/$(APP_NAME):$(IMAGE_VERSION))

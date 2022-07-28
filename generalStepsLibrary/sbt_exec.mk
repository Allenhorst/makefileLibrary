SBT_EXEC?=mkdir -p $(HOME)/.cache/coursier $(HOME)/.ivy2 $(HOME)/.sbt && \
	$(DOCKER_EXEC) run $(DOCKER_OPTIONS) --rm \
		-u $(shell id -u):$(shell id -g) \
		-v $(HOME)/.cache/coursier:/tmp/.cache-coursier \
		-v $(HOME)/.ivy2:/tmp/.ivy2 \
		-v $(HOME)/.sbt:/tmp/.sbt \
		-v $(PWD):/app \
		-e HOME=/tmp \
		$(SBT_IMG) $(SBT_OPTS) \
			-ivy /tmp/.ivy2 \
			-sbt-dir /tmp/.sbt \
			$(PROXY_SETTINGS)

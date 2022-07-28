verify: env ## verify project
	@rm -rf target/ .coverage/
	$(SBT_EXEC) clean coverage compile test coverageReport
	@cp -R target/scala-2.*/scoverage-report .coverage
	$(DOCKER_EXEC) run --rm -v $(PWD)/infra:/infra $(KUBECONFORM_IMAGE)

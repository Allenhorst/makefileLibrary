build_jars: env ## build jars
	@rm -rf target/ docker/
	@mkdir docker
	$(SBT_EXEC) clean pack
	mv target/scala-2.13/*.jar docker/$(APP_NAME).jar
	mv target/pack/lib docker/libs

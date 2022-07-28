build_docs: env ## build scala doc
	@rm -rf target/
	$(SBT_EXEC) doc

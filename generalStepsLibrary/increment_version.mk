increment_version: env ## increment version
	@echo $(shell ./infra/scripts/version.lib minor ./VERSION)

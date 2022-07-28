increment_version: env ## increment version
	$(eval NEW_APP_VERSION=$(shell echo $(APP_VERSION) | awk -F. '{print $$1+0"."$$2+1".0"}'))
	@echo "ThisBuild / version:= \"$(NEW_APP_VERSION)\"" > version.sbt

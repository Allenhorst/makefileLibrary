push_incremented_version: increment_version ## increment version and push
	$(eval NEW_APP_VERSION=$(shell $(POETRY_EXEC) version -s))
	@git checkout -b new-version/$(NEW_APP_VERSION)
	@git commit -a -m "$(APP_NAME) new version $(NEW_APP_VERSION)"
	@git push origin new-version/$(NEW_APP_VERSION)

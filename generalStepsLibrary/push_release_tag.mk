push_release_tag: env ## set release tag and push to origin
	@git tag -a "$(APP_VERSION)" -m "$(APP_NAME) $(APP_VERSION) release"
	@git push --tags origin

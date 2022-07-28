ifneq "$(GIT_BRANCH)" "master"
	IMAGE_SUFFIX?=-$(shell echo "$(GIT_BRANCH)" | tr "/" "-")-$(BUILD_VCS_SHORT_COMMIT_HASH)
else
	IMAGE_SUFFIX?=
endif

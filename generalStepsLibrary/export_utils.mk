## base utils
DOCKER_EXEC=$(SUDO)$(shell which docker)
KUBECTL_EXEC=$(shell which kubectl)
ENVSUBST_EXEC=$(shell which envsubst)
GIT_COMMIT_ID?=$(shell git rev-parse HEAD)
GIT_BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
IMAGE_SUFFIX?=$(shell echo "$(GIT_BRANCH)" | tr "/" "-")-$(shell echo $(GIT_COMMIT_ID) | head -c 7)
BUILD_VCS_SHORT_COMMIT_HASH?=$(shell git rev-parse --short HEAD)
ANCHORE_EXEC := $(shell which anchore-cli)


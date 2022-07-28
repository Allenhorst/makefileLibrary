
.DEFAULT_GOAL := help
.PHONY: build push list

help: ## This help.
		@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-29s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# list all targets
THIS_FILE := $(lastword $(MAKEFILE_LIST))
list:
	@LC_ALL=C $(MAKE) -pRrq -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'


## General setting
UPSTREAM_PROJECT := makefilelibrary
DOCKER_EXEC := $(shell which docker)
GIT_EXEC := $(shell which git)
VERSION := v1


export DOCKER_REGISTRY?=
export APP_NAME=example-$(UPSTREAM_PROJECT)
export OUTPUT_DIR=generatedMakefiles
export MAKEFILES_DIR=makefiles


env:
		$(eval IMAGE_NAME=$(DOCKER_REGISTRY)/$(APP_NAME))
		$(eval IMAGE_VERSION=$(VERSION))
		$(eval IMAGE_TAG=$(IMAGE_NAME):$(IMAGE_VERSION))
		$(eval ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
		

desc: env
		@echo "Build docker image with all makefile templates"

build: env ## Build local image
		@($(DOCKER_EXEC) build --rm -f "Dockerfile" -t $(IMAGE_TAG) .)

push: build ## Push local image to repository
		@($(DOCKER_EXEC) push $(IMAGE_TAG))

image_version: env
	@echo $(IMAGE_VERSION))

image_tag: env
	@echo $(IMAGE_TAG)

install_reqs_local:
	@pip install -r requirements.txt

generate_all_docker: image_tag
	PWD=$(pwd)
	rm -rf $(OUTPUT_DIR) && \
	mkdir $(OUTPUT_DIR) && \
	chmod 777 $(OUTPUT_DIR) && \
	docker run  -u $(shell id -u):$(shell id -g) -v $(ROOT_DIR)/$(OUTPUT_DIR):/app/generatedMakefiles/:rw -v $(ROOT_DIR)/$(MAKEFILES_DIR):/app/makefiles/:rw $(IMAGE_NAME):$(IMAGE_VERSION) generate all makefiles generatedMakefiles


build_project_docker: image_tag  ## use as <  make build_project_docker PROJECT=af-api>
	PWD=$(pwd)
	rm -rf $(OUTPUT_DIR) && \
	mkdir $(OUTPUT_DIR) && \
	chmod 777 $(OUTPUT_DIR) && \
	docker run -u $(shell id -u):$(shell id -g) -v $(ROOT_DIR)/$(OUTPUT_DIR):/app/generatedMakefiles/:rw -v $(ROOT_DIR)/$(MAKEFILES_DIR):/app/makefiles/:rw $(IMAGE_NAME):$(IMAGE_VERSION) build $(PROJECT) makefiles generatedMakefiles 


generate_all_local: install_reqs_local env

	python3 $(ROOT_DIR)/main.py generate all --indir=makefiles --outdir=generatedMakefiles

build_project_local: install_reqs_local env ##use as <  make build_project_local PROJECT=af-api>

	python3 $(ROOT_DIR)/main.py build $(PROJECT) --indir=makefiles --outdir=generatedMakefiles	

build_migrations_from_docker:generate_all_docker

	python3 $(ROOT_DIR)/buildMigrationPlan.py 

build_migrations:install_reqs_local generate_all_local

	python3 $(ROOT_DIR)/buildMigrationPlan.py 

#generate_all_docker: image_tag
#	mkdir $(OUTPUT_DIR) && \
#	chmod 777 $(OUTPUT_DIR) && \
#	docker run -v $(pwd)/$(OUTPUT_DIR):/app/$(OUTPUT_DIR):rw $(IMAGE_TAG) generate all $(OUTPUT_DIR)
#
#build_project_docker: image_tag  ## use as <  make build_project_docker PROJECT=af-api>
#	rmdir $(OUTPUT_DIR) && \
#	mkdir $(OUTPUT_DIR) && \
#	chmod 777 $(OUTPUT_DIR) && \
#	docker run -v $(pwd)/$(OUTPUT_DIR):/app/$(OUTPUT_DIR):rw $(IMAGE_TAG) build $(PROJECT) $(OUTPUT_DIR)

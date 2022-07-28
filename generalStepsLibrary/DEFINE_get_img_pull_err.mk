## call get_img_pull_err, $(IMAGE)
define get_img_pull_err
	$(DOCKER_EXEC) -l fatal pull $1 2>&1 > /dev/null
endef

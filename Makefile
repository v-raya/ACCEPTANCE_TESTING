include Makefile.settings

build:
	${INFO} "Building image"
	@ docker build -t $(REPOSITORY_NAME):$(REPOSITORY_TAG) .
	${INFO} "Build complete"

publish:
	@ docker login
	@ make build
	${INFO} "Publishing image"
	@ docker push $(REPOSITORY_NAME):$(REPOSITORY_TAG)
	@ docker logout
	${INFO} "Image published"

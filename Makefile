include Makefile.settings

test:
	${INFO} "Begin Test"
	${INFO} "Pulling latest images..."
	@ docker-compose pull
	${INFO} "Building images..."
	@ docker-compose build -t $(REPOSITORY_NAME):$(REPOSITORY_TAG)
	${INFO} "Running tests..."
	${INFO} " ... selenium:"
	@ -APP_URL=http://10.200.3.163/ CAPYBARA_DRIVER=selenium docker-compose run acceptance_test
	${INFO} " ... webkit:"
	@ -APP_URL=http://10.200.3.163/ CAPYBARA_DRIVER=webkit docker-compose run acceptance_test

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

clean:
	${INFO} "Removing dangling images..."
	@ docker images -q -f label=application=acceptance_black_box -f dangling=true | xargs -I ARGS docker rmi -f ARGS
	${INFO} "Remove reports directory"
	@ rm -r ./reports
	${INFO} "Clean complete"

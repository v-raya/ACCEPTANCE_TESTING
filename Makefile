# Project variables
DOCKER_COMPOSE_FILE ?= docker-compose.yml
TEST_TARGET_URL ?= http://accelerator.mycasebook.org/

include Makefile.settings

test:
	${INFO} "Begin Test"
	${INFO} "Pulling latest images..."
	@ docker-compose pull
	${INFO} "Building images..."
	@ docker-compose build
	${INFO} "Running tests..."
	${INFO} " ... selenium:"
	@ -CAPYBARA_DRIVER=selenium APP_URL=$(TEST_TARGET_URL) docker-compose -f $(DOCKER_COMPOSE_FILE) up acceptance_test
	@ docker cp $$(docker-compose ps -q acceptance_test):/usr/src/app/reports/. reports
	@ docker-compose -f $(DOCKER_COMPOSE_FILE) down
	${INFO} " ... webkit:"
	@ -CAPYBARA_DRIVER=webkit APP_URL=$(TEST_TARGET_URL) docker-compose -f $(DOCKER_COMPOSE_FILE) up acceptance_test
	@ docker cp $$(docker-compose ps -q acceptance_test):/usr/src/app/reports/. reports
	@ docker-compose -f $(DOCKER_COMPOSE_FILE) down

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

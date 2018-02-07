## Requirements
For local test running:
- Ruby 2.3+ with Bundler

For Docker container test runs see [Using Docker](#using-docker)
## Setup
Assuming the above requirements are satisfied:

- Set up the Ruby app:
  - `git clone git@github.com:ca-cwds/acceptance_testing.git`
  - `cd acceptance_testing`
  - `bundle install`

## Running specs

There are 3 environment variables you can use to configure the test suite:
- `APP_URL` (required): The full URL your application can be found at.
- `CAPYBARA_DRIVER` (optional): Which Capybara driver to use. Options are `selenium`, `selenium_chrome`, `selenium_chrome_headless`, `selenium_firefox`, `selenium_firefox_headless`, `xvfb_firefox`, default is `selenium`.
- `FEATURE_SET` (optional): Run specific tests specified in feature_set.yml.

## Spec results

After each test run, you can find the JUnit-formatted test results in `reports/`.

### Examples

Environment variables can be set on the current session or specified at runtime appending them before the rake command.

```
$ APP_URL=http://my-great-app.info/ CAPYBARA_DRIVER=webkit rake # Test against http://my-great-app.info using Webkit (Chrome) driver
$ APP_URL=http://192.168.2.12:3000/ rake                        # Test against http://192.168.2.12:3000 using Selenium (Firefox) driver
```

# Using Docker

### Setup
- Your machine must have [Docker](https://docs.docker.com/engine/installation/) and [Docker Machine](https://docs.docker.com/docker-for-windows/) installed.
- Also [Docker Compose](https://docs.docker.com/compose/) is needed
- Build the Docker image with: `docker-compose build`


### Running specs
To run tests with docker, call `docker-compose run`, environment variables must be set or passed on the command line.
The name of the docker-compose service must be specified as well (in this case, `acceptance_test`). 

### Examples
```
$ APP_URL=http://my-great-app.info/ CAPYBARA_DRIVER=webkit docker-compose run acceptance_test
$ APP_URL=http://10.0.1.77:3000 docker-compose run acceptance_test
```

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

There are 2 environment variables you can use to configure the test suite:
- `APP_URL` (required): The full URL your application can be found at.
- `CAPYBARA_DRIVER` (optional): Which Capybara driver to use. Options are `webkit` and `selenium`, default is `selenium`.

### Examples

Environment variables can be set on the current session or specified at runtime appending them before the rake command.

```
$ APP_URL=http://my-great-app.info/ CAPYBARA_DRIVER=webkit rake # Test against http://my-great-app.info using Webkit (Chrome) driver
$ APP_URL=http://192.168.2.12:3000/ rake                        # Test against http://192.168.2.12:3000 using Selenium (Firefox) driver
```

# Using Docker

### Setup
- Your machine must have [Docker](https://docs.docker.com/engine/installation/) installed.
- Build the Docker image with:
 `docker build -t integration_testing .`

### Running specs
To run tests with docker, call `docker run`, passing in each environment variable option with the `-e` flag.
The name of the image created must be specified as well (in this case, `integration_testing`). 
Finally append the `rake` command that will be called inside the container.

### Examples
```
$ docker run -e APP_URL=http://my-great-app.info/ -e CAPYBARA_DRIVER=webkit integration_testing rake
$ docker run -e APP_URL=http://10.0.1.77:3000 integration_testing rake
```

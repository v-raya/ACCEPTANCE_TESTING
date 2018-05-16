## Table of Content
- [Requirement](#requirement)
- [Setup](#setup)
- [Drivers](#drivers)
- [Environment Variables](#environment-variables)
- [DSL](#dsl)
- [Running specs](#running-specs)


## <a name="requirement"></a>Requirements
For local test running:
- Ruby 2.4.0 with Bundler (Recommend using [rbenv](https://github.com/rbenv/rbenv) for version control)
- [Homebrew](https://brew.sh) - **mac only**
- [Docker](https://docs.docker.com/docker-for-mac/install/)
- [Geckodriver](https://github.com/mozilla/geckodriver/releases) - (Recommend v0.18.0)
- [ChromeDriver](https://github.com/caskroom/homebrew-cask) for headless tests on local and CI builds


## <a name="setup"></a>Setup
Assuming the above requirements are satisfied:

- ### Ruby
  - `git clone git@github.com:ca-cwds/acceptance_testing.git`
  - `cd acceptance_testing`
  - `bundle install`
- ### Homebrew
  - Copy and paste in console
    - `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
- ### Docker
  - See Docker installation guide
- ### Geckodriver
  - [Download](https://docs.docker.com/docker-for-mac/install/) and unzip
  - move the unix executable file `/usr/loca/bin`
    - `mv <unzipped location of unix executable file> /usr/local/bin/`
  - In console run
    - `which geckodriver` and output should be `/usr/local/bin/geckodriver`
    - `open /usr/local/bin/geckodriver` and you should see geckodriver starting instructions. You can quit console running geckodriver.
- ### ChromeDriver
  - Copy and Paste `brew cask install chromedriver`

## <a name="drivers"></a>Drivers
- ### Available Capybara Drivers
  - `headless_chrome`
  - `selenium_chrome`
  - `selenium_chrome_headless`
  - `selenium_firefox`
- ### Defaults
  - On local `headless_chrome`
  - On CI `headless_chrome`

## <a name="environment-variables"></a>Environment Variables
- ### APP_URL
  - **Required** in order to run the specs against
    - If you have [integrated-test-environment](https://github.com/ca-cwds/integrated-test-environment) setup using the instructions provided
      - `ENV['APP_URL']='http://intake.local.cwds.io'`
    - Running localhost
      - `ENV['APP_URL']='http://localhost:<port>'`
  - **WARNING**
    - If the URL does not include 'local' in the string for local tests, you WILL have routing issues
- ### CAPYBARA_DRIVER
  - Defaults to `headless_chrome` if not defined
  - `ENV['CAPYBARA_DRIVER']=selenium_chrome`

## <a name="dsl"></a>DSL
- ### Form Helper
  - `fill_form(args)`
    - `ScreeningInformation.fill_form(name: 'John', start_date: (DateTime.now - 2))`
      - Will fill ScreeningInformation card with only the options passed
  - `fill_form_and_save(args)`
    - `Narrative.fill_form_and_save`
      - Will not fill any information for Narrative card and save card
  - `complete_form(args)`
    - `IncidentInformation.complete_form(name: 'John', start_date: (DateTime.now - 2))`
      - Will fill IncidentInformation card with options passed
      - Will fill in dummy data for options not passed
  - `complete_form_and_save(args)`
    - `WorkerSafety.complete_form`
      - Will fill in all dummy data for fields
  - `Screening.new.complete`
    - Will fill all the cards with dummy data
      - This will create a victim, reporter, and perpetrator in order to fill Allegation card
- ### Route Helper
  - Rails route style helpers
    - `root_path`
    - `snapshot_path`
    - `intake_path`
    - `new_screening_path`
    - `edit_screening_path(id: 1)`
    - `screening_path(id: 1)`
- ### Login Helper
  - `login_user(user: DEFAULT_SUPERVISIOR, path: new_screening_path)`
    - **user** option requires a hash object
    - **path** redirection after login
    - `$current_user` global variable is available for use in the specs after login


## <a name="running-specs"></a>Running specs
  - ### Locally
    - `APP_URL=http://intake.local.cwds.io CAPYBARA_DRIVER=selenium_chrome rspec spec`
  - ### Docker
    - `APP_URL=http://intake.local.cwds.io CAPYBARA_DRIVER=selenium_chrome docker-compose run --rm acceptance_test`
